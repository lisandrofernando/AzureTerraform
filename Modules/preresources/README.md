# Modules/preresources

This module provisions the pre-resources like Resource Group, Storage Account, and Key Vault.

## Role assignment helper script

A helper script is available to create (or reuse) a Service Principal, assign a role (resource-group scope by default or subscription scope with -S), and set Key Vault access policy:

Usage examples:

```bash
# Subscription-scoped Contributor with Key Vault policy
chmod +x ./Modules/preresources/scripts/assign-role.sh
# Create the service principal in a specific tenant if required (use -t)
./Modules/preresources/scripts/assign-role.sh -s <subscription-id> -k <key-vault-name> -n <sp-name> -r Contributor -S -t <tenant-id>

# Convenience: create SP in tenant, write tfvars and run terraform plan/apply
chmod +x ./Modules/preresources/scripts/setup-kv-create.sh
./Modules/preresources/scripts/setup-kv-create.sh -s <subscription-id> -g <resource-group> -k <key-vault-name> -n <sp-name> -t <tenant-id> [-a]

# Resource-group scoped role + generate tfvars file for Terraform
./Modules/preresources/scripts/assign-role.sh -s <subscription-id> -g <resource-group> -k <key-vault-name> -n <sp-name> -w Modules/preresources/credentials.auto.tfvars
```

After running the script, copy the printed `service_principal_object_id` and `service_principal_app_id` into your Terraform variables (or use the generated tfvars file). When using `-w` to write a tfvars file, the script will include the `client_secret` (if a new service principal was created), set file permissions to `600`, and attempt to add the file path to the repository's `.gitignore` (best-effort). Do NOT commit client secrets to source control.

Troubleshooting: Invalid issuer / 401 when applying Key Vault

If you see an error like: "AKV10032: Invalid issuer ... found https://sts.windows.net/<some-tenant>/" it means the authentication token presented during the apply is issued by a different AAD tenant than the Key Vault expects.

Steps to diagnose and fix:

1) Check the Key Vault's tenant and your current authenticated tenant:
   - az keyvault show -n <keyvault-name> --query properties.tenantId -o tsv
   - az account show --query tenantId -o tsv

2) Make sure Terraform is authenticating with a principal in the same tenant as the Key Vault (the tenant returned by the first command). If not:
   - Use `az login --tenant <tenant-id>` or set the service principal to the Key Vault's tenant when creating it (pass `--tenant <tenant-id>` to `az ad sp create-for-rbac`).

3) Optionally, set `service_principal_object_id` and `tenant_id` in `Modules/preresources/variables.tf` to the correct values (or leave `tenant_id` empty — Terraform will fall back to the authenticated tenant).

Module checks and safeguards added

- The module now computes an `effective_tenant` (either `var.tenant_id` if set, or the authenticated tenant) and enforces a precondition that the authenticated tenant matches the module's tenant. This causes Terraform to fail fast with a clear message if they differ.

- When `az` CLI is available, a lightweight `null_resource` check will detect an existing Key Vault and fail with a helpful message if the existing vault's tenant does not match the `effective_tenant` (this is the most common cause of AKV10032). This gives guidance like: "re-authenticate with the Key Vault tenant: az login --tenant <kv-tenant-id>".

If you'd like I can make the module more strict (for example, refuse to create a Key Vault when an existing Key Vault with the same name exists in a different tenant), or add an opt-in skip flag to disable the `az` check for environments where `az` is not available. Which option do you prefer?
