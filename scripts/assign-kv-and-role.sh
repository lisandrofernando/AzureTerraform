#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/assign-kv-and-role.sh -s <subscription-id> -k <key-vault-name> -n <sp-name> [-g <resource-group>] [-r <role>] [-S]
# Example (resource-group scope): ./scripts/assign-kv-and-role.sh -s <sub-id> -g terraform-rg -k terraformKeyVaultDemo -n my-sp -r Contributor
# Example (subscription scope): ./scripts/assign-kv-and-role.sh -s <sub-id> -k terraformKeyVaultDemo -n my-sp -r Contributor -S

ROLE="Contributor"
SUBSCOPE=false

while getopts s:g:k:n:r:S flag
do
    case "${flag}" in
        s) SUBSCRIPTION_ID=${OPTARG};;
        g) RG_NAME=${OPTARG};;
        k) KV_NAME=${OPTARG};;
        n) SP_NAME=${OPTARG};;
        r) ROLE=${OPTARG};;
        S) SUBSCOPE=true;;
    esac
done

# Validation: subscription, keyvault, sp name required; resource group required unless using subscription scope
if [[ -z "${SUBSCRIPTION_ID:-}" || -z "${KV_NAME:-}" || -z "${SP_NAME:-}" ]]; then
  echo "Missing required argument. Use -s -k -n (and optionally -g and -r). Use -S to assign role at subscription scope instead of resource-group scope."
  exit 2
fi
if [[ "$SUBSCOPE" != true && -z "${RG_NAME:-}" ]]; then
  echo "Resource group (-g) is required unless -S (subscription scope) is specified."
  exit 2
fi

# Ensure az cli installed
if ! command -v az >/dev/null 2>&1; then
  echo "az CLI not found. Please install Azure CLI: https://aka.ms/InstallAzureCli"
  exit 3
fi

# Ensure jq installed (used to parse create-for-rbac output when creating a new SP)
if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found. Please install jq to parse JSON: https://stedolan.github.io/jq/"
  exit 3
fi

SCOPE="/subscriptions/$SUBSCRIPTION_ID"
if [[ "$SUBSCOPE" != true ]]; then
  SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME"
fi

echo "Using subscription: $SUBSCRIPTION_ID"
echo "Role assignment scope: $SCOPE"
az account set --subscription "$SUBSCRIPTION_ID"

# Create or get service principal
EXISTING_SP=$(az ad sp list --filter "displayName eq '$SP_NAME'" --query "[0].appId" -o tsv || true)
if [[ -n "$EXISTING_SP" && "$EXISTING_SP" != "None" ]]; then
  echo "Service principal '$SP_NAME' already exists. AppId: $EXISTING_SP"
  APP_ID=$EXISTING_SP
  # Ensure role assignment exists at the requested scope
  EXISTING_ASSIGNMENT=$(az role assignment list --assignee "$APP_ID" --scope "$SCOPE" --query "[?roleDefinitionName=='$ROLE'] | [0]" -o tsv || true)
  if [[ -z "$EXISTING_ASSIGNMENT" ]]; then
    echo "Adding role '$ROLE' for appId $APP_ID at scope $SCOPE"
    az role assignment create --assignee "$APP_ID" --role "$ROLE" --scope "$SCOPE" || true
  else
    echo "Role '$ROLE' already assigned at scope $SCOPE"
  fi
else
  echo "Creating service principal '$SP_NAME' with role '$ROLE' scoped to '$SCOPE'"
  CREDS=$(az ad sp create-for-rbac --name "$SP_NAME" --role "$ROLE" --scopes "$SCOPE" -o json)
  APP_ID=$(jq -r .appId <<<"$CREDS")
  CLIENT_SECRET=$(jq -r .password <<<"$CREDS")
  echo "Created service principal. AppId: $APP_ID"
  echo "Store the client secret securely (not in source): $CLIENT_SECRET"
fi

# Get object id for the service principal
OBJECT_ID=$(az ad sp show --id "$APP_ID" --query objectId -o tsv)
if [[ -z "$OBJECT_ID" || "$OBJECT_ID" == "None" ]]; then
  echo "Failed to find object id for AppId $APP_ID"
  exit 4
fi

echo "Service principal object id: $OBJECT_ID"

# Assign Key Vault access policy
echo "Assigning Key Vault access policy to service principal for Key Vault: $KV_NAME"
az keyvault set-policy --name "$KV_NAME" --object-id "$OBJECT_ID" \
  --secret-permissions get list set delete backup restore \
  --key-permissions get list encrypt decrypt wrapKey unwrapKey \
  --certificate-permissions get list

# Output terraform variable settings
cat <<EOF

✅ Done.
Set the following Terraform variables (for example in a tfvars file) to allow Terraform to manage permissions:

service_principal_object_id = "$OBJECT_ID"
service_principal_app_id    = "$APP_ID"

You may optionally commit these to a secure variable mechanism or pass them through CI/CD secrets.
EOF

exit 0
