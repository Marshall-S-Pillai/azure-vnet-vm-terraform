# Azure VNet + Linux VM with Terraform modules and GitHub Actions

Creates:

- Resource group
- VNet `10.10.0.0/16` with subnet `10.10.1.0/24`
- NSG allowing SSH (port 22)
- Standard public IP
- Ubuntu 22.04 LTS VM (`Standard_B1s`) with a generated 4096-bit SSH key

Default region: **Central India**.

## Layout

```
terraform/
  main.tf
  modules/
    resource_group/
    network/          # VNet, subnet, NSG
    compute/          # PIP, NIC, Linux VM
.github/workflows/terraform.yml
```

## Prerequisites

- Azure subscription
- Terraform >= 1.6
- Azure CLI (`az login`) for local runs
- GitHub repo secrets for CI (OIDC recommended)

### GitHub secrets (OIDC)

Create an Entra ID app + service principal, grant it **Contributor** on the subscription (or a dedicated RG), add a **federated credential** for this repo (`repo:Marshall-S-Pillai/azure-vnet-vm-terraform:ref:refs/heads/main` and/or environment), then set:

| Secret | Value |
|---|---|
| `AZURE_CLIENT_ID` | App (client) ID |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID |

Workflow already sets `id-token: write` and `ARM_USE_OIDC=true`.

## Local deploy

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars — set allowed_ssh_source to YOUR_PUBLIC_IP/32

az login
terraform init
terraform plan
terraform apply
```

Save the private key (do this immediately after apply):

```bash
terraform output -raw ssh_private_key_pem > ../id_rsa
chmod 600 ../id_rsa
terraform output vm_public_ip
terraform output admin_username
```

The PEM lives in Terraform state (`sensitive`). Treat state as secret. For production, generate the key outside Terraform and pass only the public key.

## GitHub Actions

- PR / push to `main` (paths under `terraform/`): fmt, init, validate, plan
- Push to `main`: apply
- Manual **workflow_dispatch**: choose `plan`, `apply`, or `destroy`

## Connect with MobaXterm

1. Get public IP: `terraform output -raw vm_public_ip`
2. Username: `azureuser`
3. Session → **SSH** — Remote host `<public-ip>`, username `azureuser`, port `22`
4. Advanced SSH settings → **Use private key** → select `id_rsa` (PEM)
5. Start session and accept the host fingerprint

## Connect with PuTTY

1. PuTTYgen → Conversions → Import key → `id_rsa` → Save private key as `id_rsa.ppk`
2. PuTTY → Host `azureuser@<public-ip>`, port 22, SSH
3. Connection → SSH → Auth → Credentials → private key `id_rsa.ppk`
4. Save session → Open

## OpenSSH

```bash
ssh -i id_rsa azureuser@<public-ip>
```

## Destroy

```bash
terraform destroy
```

or Actions → Run workflow → `destroy`.
