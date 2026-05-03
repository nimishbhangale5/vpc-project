# 🌐 VPC with Public/Private Subnets — AWS + Terraform

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple?logo=terraform)
![VPC](https://img.shields.io/badge/AWS-VPC-yellow?logo=amazon-aws)
![EC2](https://img.shields.io/badge/AWS-EC2-red?logo=amazon-aws)

> Production-grade AWS VPC architecture with public/private subnets, Bastion Host, and NAT Gateway — fully automated with Terraform IaC.

---

## 🏗️ Architecture

```
Internet
    ↓
Internet Gateway
    ↓
┌─────────────────────────────────────┐
│              VPC (10.0.0.0/16)      │
│                                     │
│  PUBLIC SUBNET (10.0.1.0/24)        │
│  ┌─────────────┐  ┌──────────────┐  │
│  │ Bastion Host│  │ NAT Gateway  │  │
│  │ (EC2)       │  │              │  │
│  └─────────────┘  └──────┬───────┘  │
│                           │         │
│  PRIVATE SUBNET (10.0.2.0/24)       │
│  ┌─────────────────────────────┐    │
│  │ App Server (EC2)            │    │
│  │ No Public IP — Private only │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

| Component | Service |
|---|---|
| **Network** | AWS VPC, Subnets, Internet Gateway |
| **Security** | NAT Gateway, Security Groups, Bastion Host |
| **Compute** | AWS EC2 (t3.micro) |
| **IaC** | Terraform |
| **SSH Access** | RSA Key Pair + Jump Host pattern |

---

## 📁 Project Structure

```
vpc-project/
├── infrastructure/
│   └── terraform/
│       ├── main.tf             # Provider + S3 backend
│       ├── variables.tf        # Input variables
│       ├── vpc.tf              # VPC + Subnets + IGW
│       ├── routing.tf          # Route tables + NAT Gateway
│       ├── security_groups.tf  # Firewall rules
│       ├── ec2.tf              # Bastion + App Server
│       └── outputs.tf          # IPs and connection commands
├── scripts/
│   └── connect.sh              # SSH helper script
├── docs/
│   └── architecture.md
└── .gitignore
```

---

## 🔐 Security Design

### Bastion Host Security Group
| Protocol | Port | Source |
|---|---|---|
| SSH | 22 | Your IP only |

### App Server Security Group
| Protocol | Port | Source |
|---|---|---|
| SSH | 22 | Bastion SG only |
| HTTP | 80 | Bastion SG only |

> ✅ App Server has **zero direct internet exposure** — only reachable via Bastion Host

---

## 🚀 AWS Resources Created (15 Total)

| Resource | Name |
|---|---|
| VPC | vpc-project-vpc |
| Public Subnet | vpc-project-public-subnet |
| Private Subnet | vpc-project-private-subnet |
| Internet Gateway | vpc-project-igw |
| NAT Gateway | vpc-project-nat-gateway |
| Elastic IP | vpc-project-nat-eip |
| Public Route Table | vpc-project-public-rt |
| Private Route Table | vpc-project-private-rt |
| Bastion Security Group | vpc-project-bastion-sg |
| App Security Group | vpc-project-app-sg |
| Key Pair | vpc-project-key |
| Bastion Host EC2 | vpc-project-bastion |
| App Server EC2 | vpc-project-app-server |
| Route Table Associations | x2 |

---

## ✅ What Was Tested & Verified

- ✅ SSH into Bastion Host from local machine
- ✅ SSH from Bastion into Private App Server
- ✅ Private server pinged google.com via NAT Gateway
- ✅ Private server NOT directly reachable from internet
- ✅ All infrastructure destroyed cleanly with `terraform destroy`

---

## 🚀 Deploy It Yourself

```bash
# Clone the repo
git clone https://github.com/nimishbhangale5/vpc-project.git
cd vpc-project

# Generate SSH key
ssh-keygen -t rsa -b 4096 -f vpc-key -N ""

# Deploy infrastructure
cd infrastructure/terraform
terraform init
terraform apply -auto-approve

# SSH into Bastion
ssh -i ../../vpc-key ec2-user@BASTION_PUBLIC_IP

# SSH into Private Server via Bastion
ssh -i vpc-key -J ec2-user@BASTION_IP ec2-user@PRIVATE_IP

# Destroy when done (avoid NAT Gateway charges!)
terraform destroy -auto-approve
```

---

## 💰 Cost

| Service | Cost |
|---|---|
| VPC, Subnets, IGW, Route Tables | ✅ Free |
| EC2 t3.micro x2 | ✅ Free tier |
| NAT Gateway | ⚠️ ~$0.045/hr — destroy after use! |

---

## 👤 Author

**Nimish Bhangale**
- 📧 bhangalenimish@gmail.com
- 💼 [LinkedIn](https://www.linkedin.com/in/nimish-bhangale-526a42222/)
- 🐙 [GitHub](https://github.com/nimishbhangale5)