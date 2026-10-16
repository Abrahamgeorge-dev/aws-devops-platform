# AWS DevOps Platform

An end-to-end DevOps project demonstrating automated testing, containerization, vulnerability scanning, AWS infrastructure provisioning, and continuous deployment using GitHub Actions.

## Project Overview

This project deploys a Node.js application to Amazon EC2 through a CI/CD pipeline. Terraform manages the AWS infrastructure, Docker packages the application, and GitHub Actions automates testing, security scanning, image publishing, and deployment.

The project demonstrates practical skills in Cloud Computing, Infrastructure as Code (IaC), CI/CD automation, container security, and AWS operations.

## Technologies Used

- AWS EC2, VPC, IAM, ECR, and Systems Manager
- Terraform for Infrastructure as Code
- GitHub Actions for CI/CD
- Docker for containerization
- Trivy for container vulnerability scanning
- Node.js 20 and Express.js
- Jest and Supertest for automated testing

## Architecture

1. A developer pushes code to GitHub.
2. GitHub Actions checks out the code and configures Node.js.
3. Dependencies are installed and automated tests run.
4. A Docker image is built and scanned using Trivy.
5. GitHub Actions authenticates to AWS using OpenID Connect (OIDC).
6. The image is tagged with the Git commit SHA and pushed to Amazon ECR.
7. AWS Systems Manager sends deployment commands to EC2.
8. The deployment checks the replacement container's health and attempts recovery if it fails.
9. GitHub Actions verifies the public health endpoint.

## AWS Infrastructure

Terraform provisions and manages the project's AWS resources.

- **VPC:** `10.20.0.0/16`
- **Public subnet:** `10.20.1.0/24`
- **EC2 instance:** `t3.micro`, running Ubuntu
- **Container registry:** Amazon Elastic Container Registry (ECR)
- **Deployment:** AWS Systems Manager (SSM)
- **Authentication:** GitHub Actions OIDC with IAM roles

## Application Endpoints

The application exposes two HTTP endpoints:

| Endpoint | Purpose | Expected response |
|---|---|---|
| `/` | Confirms the application is running | `{"message":"AWS DevOps Platform is running"}` |
| `/health` | Checks application health | `{"status":"ok"}` |

The application listens on port `3000`.

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) automates:

1. Source code checkout
2. Node.js setup and dependency installation
3. Automated tests
4. Docker image build
5. Trivy vulnerability scan for HIGH and CRITICAL vulnerabilities
6. AWS authentication using OIDC
7. Docker image push to Amazon ECR
8. Deployment to EC2 through AWS Systems Manager
9. Application health verification

Deployments run on pushes to the `main` branch. Pull requests run the testing and build stages but do not deploy.

## Security Considerations

- GitHub Actions uses OIDC to assume an AWS IAM role instead of storing long-lived AWS access keys in GitHub.
- The Docker container runs as a non-root user.
- Trivy scans the image for HIGH and CRITICAL vulnerabilities.
- The current security group allows SSH (port 22), HTTP (port 80), and application traffic (port 3000) from `0.0.0.0/0`. Restrict SSH to trusted IP addresses or use Systems Manager Session Manager, and review whether port 3000 needs to be publicly accessible.
- Vulnerability scanning is not a guarantee that an image is completely secure.

## Run the Application Locally

### Prerequisites

Install the following tools:

- Git
- Node.js 20
- npm
- Docker (optional, for containerized execution)

### 1. Clone the Repository

```bash
git clone https://github.com/Abrahamgeorge-dev/aws-devops-platform.git
cd aws-devops-platform

```

### 2. Install Dependencies

```bash
cd app
npm ci

```

### 3. Run Automated Tests

```bash
npm test
```

The test verifies that the `/health` endpoint returns HTTP status `200` and `{"status":"ok"}`.

### 4. Start the Application

```bash
npm start
```

The application listens on port `3000`.

Open these URLs in your browser:

- http://localhost:3000/
- http://localhost:3000/health

Press `Ctrl + C` in the terminal to stop the application.

## Project Status

The application has been deployed to AWS EC2, and the CI/CD pipeline has successfully completed testing, image publishing, deployment, and health verification.

- **Live application:** http://18.169.183.8:3000
- **Health check:** http://18.169.183.8:3000/health

The public IP may change if the EC2 instance is replaced or its public IP is reassigned.

## Author

**Babaseyi Abrahamgeorge**

- GitHub: https://github.com/Abrahamgeorge-dev
- Project repository: https://github.com/Abrahamgeorge-dev/aws-devops-platform

---

This project demonstrates practical learning in AWS, DevOps automation, containerization, CI/CD, and Infrastructure as Code.
