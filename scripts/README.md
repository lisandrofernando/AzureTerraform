# Scripts: Assign Key Vault and Role to a Service Principal

This folder contains a helper script `assign-kv-and-role.sh` to create (or reuse) an Azure AD service principal, assign a role on a resource group and set Key Vault access policies.

Usage example:

```bash
chmod +x ./scripts/assign-kv-and-role.sh
# Assign role at resource-group scope (default behavior)
./scripts/assign-kv-and-role.sh -s <subscription-id> -g <resource-group> -k <key-vault-name> -n <service-principal-name> -r Contributor

# Assign role at subscription scope (use -S)
./scripts/assign-kv-and-role.sh -s <subscription-id> -k <key-vault-name> -n <service-principal-name> -r Contributor -S
```

Notes:
- The script requires `az` CLI and `jq` to parse JSON. Install them if missing.
- Keep the client secret secure (do not commit it to source control).

After running, the script prints the `service_principal_object_id` and `service_principal_app_id` values — set these in Terraform (e.g., in `Modules/preresources/variables.tf` or a `.auto.tfvars` file):

```hcl
service_principal_object_id = "<object-id-from-script>"
service_principal_app_id = "<app-id-from-script>"
```

Notes:
- The script requires `az` CLI and `jq` to parse JSON. Install them if missing.
- Keep the client secret secure (do not commit it to source control).
