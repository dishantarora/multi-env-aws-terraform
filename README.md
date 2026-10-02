# Multi-environment AWS infrastructure with Terraform

This repository provisions the same small web service in isolated **staging** and **production** environments. Each environment gets its own VPC and Terraform state, while both reuse the modules under `modules/`.

## Design

- **Separate roots and state:** `environments/staging` and `environments/production` are independent Terraform root modules. Their S3 backend examples use different object keys, so planning or applying one environment does not select or overwrite the other's state.
- **A network boundary per environment:** each root creates a dedicated VPC with two public subnets for an Application Load Balancer and two private subnets for EC2 application instances. The environment CIDRs do not overlap (`10.10.0.0/16` and `10.20.0.0/16`), leaving room for future peering or Transit Gateway connectivity.
- **One path into the application:** the load balancer accepts HTTP on port 80 from the configured CIDR list. The instance security group accepts port 80 only from the load balancer security group. EC2 instances have no public IP and no inbound SSH rule; the instance profile enables AWS Systems Manager Session Manager for administration.
- **Reusable layers:** `modules/network` owns VPC, subnets, routing, and NAT; `modules/security-groups` owns the load balancer and application rules; `modules/compute` owns the ALB, launch template, Auto Scaling group, and instance role; `modules/environment` composes those layers. Environment roots supply only their settings and backend.
- **Different availability and cost profiles:** staging uses a single NAT gateway and one desired application instance to keep the example's baseline cost lower. Production uses a NAT gateway in each AZ, at least two application instances, and ALB deletion protection. NAT gateways and an ALB have ongoing charges; adjust the environment settings to fit your budget and availability needs.
- **No application secrets in Terraform:** the example page is configured with a plain message. Put credentials in a managed secret store and grant narrowly scoped access if the service later needs secrets.

The example is intentionally a compact web tier rather than a complete production platform. It does not configure HTTPS, DNS, WAF, centralized logging, backups, or a deployment pipeline. Add those based on the service's requirements.

## Prerequisites

- Terraform 1.10 or later
- AWS credentials with permissions to create VPC, EC2, ELB, IAM, Auto Scaling, and S3 backend resources
- An S3 bucket for Terraform state, created before `terraform init`

The backend uses S3's native state locking (`use_lockfile = true`), supported by Terraform 1.10+. Enable bucket versioning and block public access on the state bucket. The bucket is a shared prerequisite and is deliberately not created by these environment stacks, avoiding a state bootstrap cycle.

## Configure remote state

For each environment, copy its backend example and replace the bucket name and region with your own:

```sh
cp environments/staging/backend.hcl.example environments/staging/backend.hcl
cp environments/production/backend.hcl.example environments/production/backend.hcl
```

The examples use different state keys in the same bucket. Keep the keys distinct even if you use separate buckets. Backend configuration is local and ignored by Git.

## Plan or apply an environment

Copy the environment values file, then initialize and plan from that environment's directory:

```sh
cp environments/staging/terraform.tfvars.example environments/staging/terraform.tfvars
terraform -chdir=environments/staging init -backend-config=backend.hcl
terraform -chdir=environments/staging plan
terraform -chdir=environments/staging apply
```

Use `environments/production` for production. Review the plan before applying. The load balancer DNS name is printed as `service_url` after apply. To remove an environment, run `terraform -chdir=environments/<environment> destroy` with the matching backend configuration.

## State and environment isolation

This layout uses separate root directories and S3 backend keys instead of Terraform workspaces. Separate roots make environment-specific settings and plans explicit, and backend keys provide independent state locking and recovery. The staging key is `multi-env-aws-terraform/staging/terraform.tfstate`; production uses `multi-env-aws-terraform/production/terraform.tfstate`.

The remote state bucket should have versioning enabled so an operator can recover an earlier state object. State can contain sensitive infrastructure metadata, so the bucket should be access-controlled and encrypted. Do not commit `backend.hcl`, `terraform.tfvars`, state files, or credentials.

## Changing the example

- Change CIDRs and instance sizing in the relevant `terraform.tfvars`.
- Restrict `allowed_ingress_cidrs` to the intended client networks, or set up HTTPS and DNS before exposing a real service.
- Set staging `nat_gateway_mode = "single"` for lower cost; set production to `"per_az"` for AZ-local egress and better resilience to a single NAT gateway failure.
- Set `min_size`, `desired_capacity`, and `max_size` for the service's load and availability requirements.
- The AMI is resolved from AWS's public Amazon Linux 2023 SSM parameter at plan/apply time, so new instances use the current supported image without hard-coding an AMI ID.
