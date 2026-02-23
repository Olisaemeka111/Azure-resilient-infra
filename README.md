Multi-Region Secure Azure Architecture (Terraform)

This project implements a multi‑region secure Azure landing zone using Terraform.  
It currently provisions:

- Primary + secondary regions with hub/spoke VNets.
- Azure Firewall in each hub.
- AKS clusters (primary = prod, secondary = standby) in app spokes.
- Azure SQL with a primary database and geo‑replica.
- Storage accounts (GRS) in both regions.
- Key Vault in the secondary region.
- Azure Front Door Standard as the global entry point.

The code under `envs/*` is the *current source of truth* for how this stack is deployed.

Prerequisites

- Terraform: v1.4+ (v1.6+ recommended).
- Azure CLI: logged in via `az login`.
- Azure subscription: set the active subscription:

  ```powershell
  az account set --subscription "<SUBSCRIPTION_ID>"
  ```

What Gets Deployed (Current State)

- Resource groups
  - `azurerm_resource_group.primary` and `azurerm_resource_group.secondary` created from `primary_rg_name` / `secondary_rg_name`.
- Networking
  - Hub/spoke VNets in each region:
    - Hub VNets: `*-hub-vnet-primary`, `*-hub-vnet-secondary`.
    - App spokes: `*-app-spoke-primary`, `*-app-spoke-secondary`.
    - Data spokes: `*-data-spoke-primary`, `*-data-spoke-secondary`.
  - Subnets:
    - `AzureFirewallSubnet` in each hub.
    - `aks-subnet` in each app spoke.
    - `sql-subnet` in each data spoke.
- Security
  - `azurerm_firewall.primary` and `azurerm_firewall.secondary` with dedicated public IPs.
- Compute (AKS)
  - `azurerm_kubernetes_cluster.aks_primary` (prod) and `azurerm_kubernetes_cluster.aks_secondary` (standby) with:
    - Node counts from `aks_primary_node_count` / `aks_secondary_node_count`.
    - VM size from `aks_node_size`.
    - Azure CNI networking and Azure network policy.
- Data
  - `azurerm_mssql_server.primary` / `azurerm_mssql_server.secondary`.
  - `azurerm_mssql_database.primary` with `sql_sku_name`.
  - `azurerm_mssql_database.secondary_geo_replica` as a geo‑replica of the primary DB.
- Storage
  - `azurerm_storage_account.primary` / `azurerm_storage_account.secondary`:
    - Names `${storage_account_name_prefix}pri` and `${storage_account_name_prefix}sec`.
    - `Standard` tier, `GRS`, `min_tls_version = "TLS1_2"`, no public blob access.
- Key Vault
  - `azurerm_key_vault.secondary` in the secondary region using `tenant_id`.
- Global entry (Front Door)
  - `azurerm_cdn_frontdoor_profile.this` (Standard_AzureFrontDoor).
  - `azurerm_cdn_frontdoor_endpoint.this` exposing a global hostname.
- Outputs
  - `primary_rg_name`, `secondary_rg_name`.
  - `aks_primary_name`, `aks_secondary_name`.
  - `sql_primary_fqdn`.
  - `afd_endpoint_hostname`.

Repo Structure

Environments (root configurations)

Each environment has its own root Terraform configuration and `tfvars` file:

- `envs/dev/`
  - `main.tf`, `variables.tf`
  - `terraform.tfvars.example` → copy/rename to `terraform.tfvars`
- `envs/test/`
  - `main.tf`, `variables.tf`
  - `terraform.tfvars.example` → copy/rename to `terraform.tfvars`
- `envs/prod/`
  - `main.tf`, `variables.tf`
  - `terraform.tfvars.example` → copy/rename to `terraform.tfvars`

All three environments call the same orchestration module: `modules/multi_region_secure_azure`.

Modules (building blocks)

- `modules/multi_region_secure_azure/`
  - Current orchestration module: implements the full multi‑region stack (RGs, VNets, subnets, firewalls, AKS, SQL + geo‑replica, Storage, Key Vault, Front Door) and exposes outputs such as RG names, AKS names, SQL FQDN, and Front Door hostname.
- `modules/region_stack/`
  - Reusable per‑region stack for hub/spoke and regional resources. The current orchestration module implements these resources inline but this module remains available for refactoring or alternative compositions.
- `modules/sql_geo_replica/`
  - SQL + geo‑replica pattern. The current orchestration module contains equivalent logic inline.
- `modules/global_frontdoor/`
  - Azure Front Door pattern (profile + endpoint). Also currently implemented inline in the orchestration module.

Configuration (`tfvars` per environment)

For each environment, start by copying the example file and editing values (CIDRs, names, subscription/tenant IDs, etc.):

- `envs/dev/terraform.tfvars.example`
- `envs/test/terraform.tfvars.example`
- `envs/prod/terraform.tfvars.example`

Example (PowerShell, dev environment):

```powershell
cd "C:\Users\olisa\OneDrive\Desktop\Azure infrastructure\envs\dev"
Copy-Item terraform.tfvars.example terraform.tfvars
# Open terraform.tfvars and update values as needed
```

Key variables you must review in each environment’s `terraform.tfvars`:

- **name_prefix**: base name used for all resources in that environment (e.g. `mr-secure-dev`).
- **tenant_id**: Azure AD tenant ID (used by Key Vault).
- **primary_location / secondary_location**: Azure regions (e.g. `uksouth`, `ukwest`).
- **Resource group names**: `primary_rg_name` and `secondary_rg_name`.
- **CIDR ranges**:
  - `primary_hub_address_space`, `secondary_hub_address_space`.
  - `primary_app_spoke_address_space`, `primary_data_spoke_address_space`.
  - `secondary_app_spoke_address_space`, `secondary_data_spoke_address_space`.
  - Subnet prefixes for firewall, AKS, and SQL.
- **AKS settings**: `aks_primary_node_count`, `aks_secondary_node_count`, `aks_node_size`.
- **SQL settings**: `sql_admin_username`, `sql_admin_password`, `sql_sku_name`.
- **Storage**: `storage_account_name_prefix` (short, globally unique prefix).
- **tags**: a map of tags applied to all resources (e.g. `environment`, `workload`).

The `envs/dev/terraform.tfvars.example` file shows a **working example** of how these are wired together.

Deployment Instructions (per environment)

1. Choose an environment folder (`envs/dev`, `envs/test`, or `envs/prod`).
2. **Copy and edit tfvars**:

   ```powershell
   cd "C:\Users\olisa\OneDrive\Desktop\Azure infrastructure\envs\dev"
   Copy-Item terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars to match your subscription, CIDRs, and naming
   ```

3. **Initialize and deploy**:

   ```powershell
   terraform init
   terraform plan
   terraform apply
   ```

4. **Repeat** the same steps in `envs\test` and `envs\prod` when you are ready to deploy those environments.

Using Outputs

After `terraform apply`, the environment will print useful outputs. For example:

- Resource groups: `primary_rg_name`, `secondary_rg_name`.
- AKS:
  - Use `aks_primary_name` / `aks_secondary_name` with `az aks get-credentials` to connect clusters.
- SQL:
  - Use `sql_primary_fqdn` to connect application workloads to the primary database.
- Front Door:
  - Use `afd_endpoint_hostname` as the public entrypoint (or map a custom domain).

Operational Notes

Secrets handling
  - Do not commit real `terraform.tfvars` with `sql_admin_password` or other secrets.
  - Prefer environment variables (e.g. `TF_VAR_sql_admin_password`) or a secure secret store.
- Terraform state
  - All environments currently use the **local backend** (`backend "local"` in each env’s `main.tf`).
  - For shared/team use, configure a remote backend (e.g. Azure Storage with state locking) separately for `dev`, `test`, and `prod`.
- Naming constraints
  - `storage_account_name_prefix` must produce Storage account names that are:
    - Globally unique.
    - All lowercase.
    - Total name length within Azure’s 3–24 character limit.

