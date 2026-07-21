# 3 Tier Infra Terraform Build w/ SRE Chaos Engineering

This project demonstrates IaC provisioning and SRE chaos engineer. Also, this projest addresses 4 fundemental reliability challenges:

- Single Points of Failure (SPOFs) & Regional Outages
- Insecure Direct Exposure & "Configuration Drift"
- Manual Incident Response & High MTTR (Mean Time to Recovery)
- "Hope-Based" Reliability Testing

## This Project Features:

- **Tier 1 (Public Ingress):** Internet Gateway and Application Load Balancer (ALB) distributed across public subnets in multiple AZs.
- **Tier 2 (Private Application):** EC2 instances managed by an Auto Scaling Group (ASG) running inside isolated private subnets. Outbound internet access for patching is facilitated through a NAT Gateway.
- **Tier 3 (Isolated Database):** Multi-AZ Amazon RDS PostgreSQL instance deployed across private database subnets with synchronous replication and automated failover.
- **Network Security:** Layered, stateful AWS Security Groups enforcing strict traffic flow down the stack: Internet ➔ ALB ➔ App Tier ➔ DB Tier.
- **Chaos Engineering:** Integrated AWS FIS execution roles and experiment templates to test and measure system steady-state behavior under failure.

## Architecture Diagram

<img width="731" height="409" alt="sre-3tier-terraform" src="https://github.com/user-attachments/assets/19f78e3a-069b-4907-8c60-f8451519c90c" />

## Step-by-Step Instructions to Deploy and Run:

1. Configure Terraform files
2. Initialize Terraform repo

```bash
terraform init
```

3. Review Terraform files for format and syntax

```bash
terraform fmt
```

4. Review Execution Plan

```bash
terraform plan
```

5. Provision Resources

```bash
terraform apply
```

Upon successful completion, Terraform will output the target endpoints:

```bash
alb_dns_name = "http://sre-alb-XXXXXXXX.us-east-1.elb.amazonaws.com"
asg_name     = "sre-asg"
fis_role_arn = "arn:aws:iam::XXXXXXXXXXX:role/sre-fis-execution-role"
rds_endpoint = "sre-db-instance.xxxx.us-east-1.rds.amazonaws.com:5432"
```

<img width="722" height="162" alt="output1" src="https://github.com/user-attachments/assets/3dd689de-345d-484e-8788-85b7c964b7dc" />

6.  Observability & Steady-State Verification

Before injecting failure, verify that traffic is load-balanced across multiple Availability Zones in real time.

```bash

ALB_URL=$(terraform output -raw alb_dns_name)

while true; do
  RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" "$ALB_URL")
  STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)
  BODY=$(echo "$RESPONSE" | grep "Served from")
  echo "[$(date +'%T')] Status: $STATUS | $BODY"
  sleep 1
done
```

Expected Output:

```bash
[12:00:01] Status: 200 | <h1>SRE Resiliency Test OK</h1><p>Served from Instance: <b>i-0a1234567</b> in AZ: <b>us-east-1a</b></p>
[12:00:02] Status: 200 | <h1>SRE Resiliency Test OK</h1><p>Served from Instance: <b>i-0b9876543</b> in AZ: <b>us-east-1b</b></p>
```

7. Monitor Health State (AWS CLI)

```bash
TG_ARN=$(aws elbv2 describe-target-groups --names "sre-app-tg" --query "TargetGroups[0].TargetGroupArn" --output text)

watch -n 2 "aws elbv2 describe-target-health --target-group-arn $TG_ARN --query 'TargetHealthDescriptions[*].[Target.Id, TargetHealth.State]' --output table"
```
