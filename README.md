# Multi-Region Secure Azure Architecture (Terraform)

Enterprise-grade, multi-region Azure landing zone with hub-spoke networking, Defender for Cloud,
private endpoints, ACR, AKS, SQL geo-replication, and full CI/CD security scanning.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       Shared Platform Services                          │
│  Azure Monitor + Log Analytics │ Defender for Cloud │ Azure Policy      │
│  RBAC + PIM │ Entra ID │ Azure Container Registry (Premium, Private)    │
└─────────────────────────────────────────────────────────────────────────┘
          │                                          │
┌─────────┴──────────────┐             ┌─────────────┴────────────┐
│     PRIMARY REGION      │             │     SECONDARY REGION      │
│  (UK South — Active)    │◄────Peer───►│  (UK West — Standby)      │
│                         │             │                           │
│  Hub VNet               │             │  Hub VNet                 │
│  ├─ AzureFirewallSubnet │             │  ├─ AzureFirewallSubnet   │
│  ├─ AzureBastionSubnet  │             │  ├─ AzureBastionSubnet    │
│  └─ GatewaySubnet*      │             │  └─ GatewaySubnet*        │
│                         │             │                           │
│  App Spoke              │             │  App Spoke                │
│  ├─ AKS nodes           │             │  └─ AKS nodes (standby)   │
│  └─ App Service*        │             │                           │
│                         │             │  Data Spoke               │
│  Data Spoke             │             │  ├─ SQL subnet             │
│  ├─ SQL subnet          │             │  ├─ Private endpoints      │
│  └─ Private endpoints   │             │  └─ Key Vault              │
└─────────────────────────┘             └───────────────────────────┘
          │                                          │
          └──────────── Azure Front Door ────────────┘
```
\* Optional: enabled via `create_vpn_gateway` / `create_app_service` flags.

---

## What Gets Deployed

| Category | Resources |
|---|---|
| **Networking** | Hub VNet + 3 subnets (Firewall, Bastion, Gateway) per region; App Spoke (AKS, AppService); Data Spoke (SQL, Private Endpoints); hub-spoke peering + cross-region hub peering |
| **Security** | Azure Firewall Standard (network + application rules), Azure Bastion Standard, VPN Gateway (optional) |
| **Compute** | AKS (Azure CNI, Network Policy, Entra ID RBAC), AcrPull role assignment |
| **Container Registry** | ACR Premium, private endpoint, geo-replication to secondary region |
| **Data** | Azure SQL (primary + geo-replica), auto-failover group, private endpoints |
| **Storage** | Storage Account (GRS, TLS 1.2, no public blob), private endpoint |
| **Key Vault** | Key Vault in secondary region, AKS access policy, private endpoint |
| **Private DNS** | 4 private DNS zones (SQL, Blob, Key Vault, ACR) linked to all 6 VNets |
| **Monitoring** | Log Analytics Workspace, Action Group (email alerts), metric alert (high CPU), diagnostic settings on all resources |
| **Governance** | Defender for Cloud (7 tiers: VMs, SQL, AKS, ACR, Storage, ARM, DNS), 5 Azure Policy assignments, ops Contributor RBAC |
| **Global** | Azure Front Door (Standard) with global endpoint |

---

## Repo Structure

```
.
├── .gitignore
├── Makefile                        # make init/plan/apply ENV=dev|test|prod
├── README.md
├── .github/
│   └── workflows/
│       └── terraform.yml           # CI/CD: SAST → image scan → validate → plan/apply
│
├── envs/
│   ├── dev/                        # Development environment
│   │   ├── main.tf                 # Root config + module call
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars.example
│   ├── test/                       # Test environment
│   └── prod/                       # Production environment
│
└── modules/
    ├── multi_region_secure_azure/  # Orchestration module
    │   ├── main.tf                 # Required providers only
    │   ├── resource_groups.tf
    │   ├── compute.tf              # region_stack modules + AcrPull assignments
    │   ├── networking.tf           # Cross-region hub peering
    │   ├── data.tf                 # SQL geo-replica module
    │   ├── global.tf               # Monitoring, ACR, Governance, Front Door
    │   ├── private_dns.tf          # 4 DNS zones + VNet links (all 6 VNets)
    │   ├── private_endpoints.tf    # SQL x2, Storage x2, Key Vault
    │   ├── locals.tf               # AKS service CIDRs
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── region_stack/               # Per-region hub-spoke stack
    │   ├── networking.tf           # VNets, subnets, peering
    │   ├── security.tf             # Azure Firewall + rules
    │   ├── bastion.tf              # Bastion + optional VPN Gateway
    │   ├── compute.tf              # AKS + AcrPull role
    │   ├── storage.tf              # Storage Account + network rules
    │   ├── app_service.tf          # Optional App Service + VNet integration
    │   ├── key_vault.tf            # Optional Key Vault + AKS access policy
    │   ├── diagnostics.tf          # Diagnostic settings → Log Analytics
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── monitoring/                 # Log Analytics + Action Group
    ├── container_registry/         # ACR Premium + private endpoint + geo-replication
    ├── governance/                 # Defender for Cloud + Azure Policy + RBAC
    ├── sql_geo_replica/            # SQL servers + failover group
    ├── global_frontdoor/           # Azure Front Door profile + endpoint
    └── cross_region_peering/       # Hub-to-hub VNet peering
```

---

## Quick Start

### Prerequisites

- Terraform >= 1.6
- Azure CLI — log in: `az login`
- Set active subscription: `az account set --subscription "<SUBSCRIPTION_ID>"`

### Deploy an environment

```bash
# Using Makefile (recommended)
make init ENV=dev
make plan ENV=dev
make apply ENV=dev

# Or manually
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — update subscription_id, tenant_id, emails, etc.
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

---

## Configuration Reference

Each environment's `terraform.tfvars.example` contains all required variables.
Key variables to update before deploying:

| Variable | Description | Required |
|---|---|---|
| `name_prefix` | Base name for all resources (`mr-secure-dev`) | Yes |
| `tenant_id` | Azure AD tenant ID | Yes |
| `subscription_id` | Azure subscription ID (Defender + Policy scope) | Yes |
| `primary_rg_name` | Primary resource group name | Yes |
| `secondary_rg_name` | Secondary resource group name | Yes |
| `*_address_space` | VNet CIDR ranges (must not overlap across envs) | Yes |
| `*_subnet_prefix` | Subnet CIDR ranges (within their VNet space) | Yes |
| `primary_hub_bastion_subnet_prefix` | /26 minimum for Azure Bastion | Yes |
| `primary_private_endpoints_subnet_prefix` | Subnet for private endpoints | Yes |
| `registry_name` | ACR name (globally unique, alphanumeric) | Yes |
| `alert_email` | Email for operational alerts | Yes |
| `security_contact_email` | Email for Defender for Cloud alerts | Yes |
| `sql_admin_password` | Set via `TF_VAR_sql_admin_password` — never commit | Yes |
| `create_vpn_gateway` | Deploy VPN Gateways (default: false) | No |
| `create_app_service` | Deploy App Services (default: false) | No |
| `ops_principal_id` | Azure AD group ObjectId for ops RBAC (default: null) | No |

### CIDR Layout (per environment)

| Env | Primary Hub | Primary App | Primary Data | Secondary Hub | Secondary App | Secondary Data |
|---|---|---|---|---|---|---|
| dev | 10.0.0.0/16 | 10.2.0.0/16 | 10.3.0.0/16 | 10.1.0.0/16 | 10.4.0.0/16 | 10.5.0.0/16 |
| test | 10.10.0.0/16 | 10.12.0.0/16 | 10.13.0.0/16 | 10.11.0.0/16 | 10.14.0.0/16 | 10.15.0.0/16 |
| prod | 10.20.0.0/16 | 10.22.0.0/16 | 10.23.0.0/16 | 10.21.0.0/16 | 10.24.0.0/16 | 10.25.0.0/16 |

AKS service CIDRs (never overlap with VNet spaces):
- Primary: `10.240.0.0/24` / DNS `10.240.0.10`
- Secondary: `10.241.0.0/24` / DNS `10.241.0.10`

---

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform.yml`) implements a full secure pipeline:

```
Push / PR
  │
  ├── SAST (tfsec)          ← Terraform security linting
  ├── Image Scan (Trivy)    ← Dockerfile / dependency vulnerability scan
  │
  ├── Validate (dev, test, prod)  ← fmt check + tf validate
  │
  ├── Plan (PR only)        ← Plans dev + test, posts diff as PR comment
  │
  ├── Deploy Dev            ← Auto on push to develop + ACR image push (Trivy scanned)
  └── Deploy Prod           ← Manual approval gate + ACR image push (Trivy scanned)
```

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `ARM_CLIENT_ID` | Service principal client ID |
| `ARM_CLIENT_SECRET` | Service principal secret |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure tenant ID |
| `SECRETS_KV_NAME_DEV` | Name of the dev ops Key Vault (e.g. `ops-kv-mr-dev`) |
| `SECRETS_KV_NAME_TEST` | Name of the test ops Key Vault |
| `SECRETS_KV_NAME_PROD` | Name of the prod ops Key Vault |
| `ACR_LOGIN_SERVER_DEV` | Dev ACR login server (e.g. `mrsecuredevacr.azurecr.io`) |
| `ACR_LOGIN_SERVER_PROD` | Prod ACR login server |

> `SQL_ADMIN_PASSWORD` is **not** a GitHub secret — it is stored in and retrieved from Azure Key Vault.

---

## Secrets Management (Azure Key Vault)

Sensitive values are **never** stored in tfvars files or as GitHub repository secrets.
They live in a per-environment "ops" Azure Key Vault and are injected by the CI/CD pipeline at runtime.

### Secrets stored in Key Vault

| Key Vault secret name  | Purpose                             |
|------------------------|-------------------------------------|
| `sql-admin-password`   | SQL Server administrator password   |
| `sql-admin-username`   | SQL Server administrator username   |

### 1. Bootstrap the ops Key Vault (run once per environment)

```bash
ENV=dev   # change to: test | prod
RG=rg-ops-${ENV}
KV_NAME=ops-kv-mr-${ENV}
LOCATION=uksouth

# Create a dedicated ops resource group and Key Vault
az group create --name $RG --location $LOCATION
az keyvault create \
  --name $KV_NAME \
  --resource-group $RG \
  --location $LOCATION \
  --sku standard \
  --enable-rbac-authorization true

# Find your CI/CD service principal's object ID
SP_OBJECT_ID=$(az ad sp show --id $ARM_CLIENT_ID --query id -o tsv)

# Grant the service principal "Key Vault Secrets User" (read) access
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee-object-id $SP_OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --scope $(az keyvault show --name $KV_NAME -o tsv --query id)

# Populate secrets (run interactively — never in a script committed to git)
az keyvault secret set --vault-name $KV_NAME --name sql-admin-password --value "YourStr0ngP@ssword!"
az keyvault secret set --vault-name $KV_NAME --name sql-admin-username --value "sqladmin${ENV}"
```

### 2. Add GitHub secrets

In **Settings → Secrets and variables → Actions**, add:

| Secret name            | Value                        |
|------------------------|------------------------------|
| `SECRETS_KV_NAME_DEV`  | `ops-kv-mr-dev`              |
| `SECRETS_KV_NAME_TEST` | `ops-kv-mr-test`             |
| `SECRETS_KV_NAME_PROD` | `ops-kv-mr-prod`             |

### 3. How the pipeline uses Key Vault

Each deploy job in `.github/workflows/terraform.yml`:
1. Authenticates to Azure with the service principal
2. Calls `azure/get-keyvault-secrets@v1` to retrieve `sql-admin-password`
3. Passes it to Terraform as `TF_VAR_sql_admin_password` — it is **never** logged or persisted

### Running locally

```bash
# Set the secret as an environment variable before plan/apply
export TF_VAR_sql_admin_password="YourStr0ngP@ssword!"

cd envs/dev
terraform init
terraform plan -var-file=terraform.tfvars
```

### Rotating a secret

```bash
# Update the secret in Key Vault — the next pipeline run picks it up automatically
az keyvault secret set --vault-name ops-kv-mr-dev --name sql-admin-password --value "NewP@ssword2026!"
```

---

## Outputs

After `terraform apply`, key outputs available via `terraform output`:

| Output | Description |
|---|---|
| `aks_primary_name` | Primary AKS cluster name (use with `az aks get-credentials`) |
| `aks_secondary_name` | Secondary AKS cluster name |
| `sql_primary_fqdn` | Primary SQL server FQDN |
| `afd_endpoint_hostname` | Front Door global hostname |
| `acr_login_server` | ACR login server URL |
| `monitoring_workspace_id` | Log Analytics Workspace resource ID |
| `primary_bastion_id` | Primary Bastion resource ID |
| `secondary_key_vault_id` | Secondary Key Vault resource ID |
| `primary_firewall_private_ip` | Primary Firewall private IP |

---

## Operational Notes

**Secrets**
- Never commit `terraform.tfvars` — it is in `.gitignore`.
- Pass `sql_admin_password` via `TF_VAR_sql_admin_password` environment variable.

**Terraform State**
- All envs use `backend "local"` by default.
- For team use, configure an Azure Storage remote backend per environment with state locking.

**Optional Features**
- `create_vpn_gateway = true` — deploys VPN Gateways; requires `*_hub_gateway_subnet_prefix` to be set.
- `create_app_service = true` — deploys App Services; requires `*_app_service_subnet_prefix` to be set.
- Both are enabled by default in the prod tfvars example.

**AKS Access**
```bash
az aks get-credentials --resource-group <primary_rg_name> --name <aks_primary_name>
kubectl get nodes
```

**Naming Constraints**
- `storage_account_name_prefix` + `pri`/`sec` suffix must be globally unique, lowercase, 3–24 chars total.
- `registry_name` must be globally unique, alphanumeric, 5–50 chars.
