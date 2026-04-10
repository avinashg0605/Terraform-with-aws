# 🚀 AWS 3-Tier Architecture using Terraform (Production Grade)

## 📌 Project Overview

This project demonstrates a **production-grade 3-tier architecture on AWS** using **Terraform (Infrastructure as Code)**.

It follows industry best practices including:

* High availability (Multi-AZ)
* Auto scaling
* Secure networking (private subnets)
* Load balancing
* Modular Terraform design

---

## 🧠 Architecture

```
Internet
   ↓
Public ALB
   ↓
Web Tier (ASG - Apache)
   ↓
Internal ALB
   ↓
App Tier (ASG - Node.js)
   ↓
RDS (MySQL - Private)
```

---

## 🏗️ Components Used

### 🌐 Networking

* VPC
* Public & Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

### 🔐 Security

* Security Groups (Layered access)
* Bastion Host (SSH access)

### ⚖️ Load Balancing

* Public Application Load Balancer
* Internal Application Load Balancer

### ⚙️ Compute

* Auto Scaling Groups (Web + App)
* Launch Templates

### 🗄️ Database

* Amazon RDS (MySQL)
* DB Subnet Group

---

## 📁 Terraform Modules

| Module          | Description                      |
| --------------- | -------------------------------- |
| vpc             | Creates networking components    |
| security-groups | Manages all SG rules             |
| ec2             | Bastion host                     |
| alb             | Public & internal load balancers |
| asg             | Web & App auto scaling           |
| rds             | Database layer                   |

---

## 🔄 Data Flow

1. User sends request to Public ALB
2. ALB routes traffic to Web Tier (ASG)
3. Web Tier communicates with App Tier via Internal ALB
4. App Tier interacts with RDS database
5. Response flows back to user

---

## 🔐 Security Design

* No direct access to private instances
* SSH only via Bastion Host
* Database accessible only from App Tier
* Layered Security Groups (least privilege)

---

## ⚙️ How to Deploy

### 1️⃣ Clone Repository

```bash
git clone https://github.com/your-username/aws-3tier-architecture-terraform.git
cd aws-3tier-architecture-terraform
```

---

### 2️⃣ Initialize Terraform

```bash
terraform init
```

---

### 3️⃣ Plan Infrastructure

```bash
terraform plan
```

---

### 4️⃣ Apply

```bash
terraform apply
```

---

### 5️⃣ Access Application

* Use ALB DNS output
* Open in browser

---

## 📊 Features

✔ Modular Terraform code
✔ Scalable architecture
✔ Secure by design
✔ High availability
✔ Auto-healing infrastructure

---

## 💡 Future Improvements

* Add HTTPS (ACM + Route53)
* Add CI/CD (Jenkins / GitHub Actions)
* Use AWS Secrets Manager for DB credentials
* Add CloudWatch monitoring & alerts
* Containerize using Docker & Kubernetes

---

## 🎯 Learning Outcomes

* Designed real-world AWS architecture
* Implemented Infrastructure as Code
* Understood VPC & networking deeply
* Built scalable and secure systems

---

## 👨‍💻 Author

**Avinash G**
DevOps Engineer | AWS | Terraform | Docker | Kubernetes

---

## ⭐ If you like this project

Give it a ⭐ on GitHub and share it!

---
