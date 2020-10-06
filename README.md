# Sandbox

## CICD Trade Study

Evaluated both CircleCI and GitHub Actions

CircleCI config lives under .circleci/config.yml

GitHub Action config lives under .github/workflows/main.yml

## Infrastructure as Code Trade Study

### Structure

This repo contains sample code to evaluate Pulumi and Terraform.

There is one folder with all of the Pulumi related files and another with the Terraform.

Both folders implement the exact same infrastructure on GCP
- VPC
- 1 Public Subnet
- 1 Private Subnet
- Router
- NAT Gateway
- Firewall Ruels

### Execution
Note: You may have to sign into the pulumi web console as well as sign into gcloud

```bash
# Pulumi
pulumi config set <key1> <value1>
pulumi config set <key2> <value2>
pulumi up

# Terraform
terraform init
terraform apply
```
