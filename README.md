# 3 Tier Infra Terraform Build w/ SRE Chaos Engineering

This project demonstrates IaC provisioning and SRE chaos engineer. Also, this projest addresses 4 fundemental reliability challenges: 
  * Single Points of Failure (SPOFs) & Regional Outages 
  * Insecure Direct Exposure & "Configuration Drift" 
  * Manual Incident Response & High MTTR (Mean Time to Recovery)
  * "Hope-Based" Reliability Testing

## This Project Features:
- **Tier 1 (Public Ingress):** Internet Gateway and Application Load Balancer (ALB) distributed across public subnets in multiple AZs.
- **Tier 2 (Private Application):** EC2 instances managed by an Auto Scaling Group (ASG) running inside isolated private subnets. Outbound internet access for patching is facilitated through a NAT Gateway.
- **Tier 3 (Isolated Database):** Multi-AZ Amazon RDS PostgreSQL instance deployed across private database subnets with synchronous replication and automated failover.
- **Network Security:** Layered, stateful AWS Security Groups enforcing strict traffic flow down the stack: Internet ➔ ALB ➔ App Tier ➔ DB Tier.
- **Chaos Engineering:** Integrated AWS FIS execution roles and experiment templates to test and measure system steady-state behavior under failure.

## Architecture Diagram

<img width="731" height="409" alt="sre-3tier-terraform" src="https://github.com/user-attachments/assets/19f78e3a-069b-4907-8c60-f8451519c90c" />
