# SRE Chaos Engineering Exercise - 3 Tier Terraform

This project demonstrates IaC provisioning and SRE chaos engineer. Also, this projest addresses 4 fundemental reliability challenges: 1. Single Points of Failure (SPOFs) & Regional Outages 2. Insecure Direct Exposure & "Configuration Drift" 3. Manual Incident Response & High MTTR (Mean Time to Recovery) 4. "Hope-Based" Reliability Testing

## Architecture Diagram

- **Tier 1 (Public Ingress):** Internet Gateway and Application Load Balancer (ALB) distributed across public subnets in multiple AZs.
- **Tier 2 (Private Application):** EC2 instances managed by an Auto Scaling Group (ASG) running inside isolated private subnets. Outbound internet access for patching is facilitated through a NAT Gateway.
- **Tier 3 (Isolated Database):** Multi-AZ Amazon RDS PostgreSQL instance deployed across private database subnets with synchronous replication and automated failover.
- **Network Security:** Layered, stateful AWS Security Groups enforcing strict traffic flow down the stack: Internet ➔ ALB ➔ App Tier ➔ DB Tier.
- **Chaos Engineering:** Integrated AWS FIS execution roles and experiment templates to test and measure system steady-state behavior under failure.
