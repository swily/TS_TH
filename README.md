# TS_TH

# Tailscale Terraform Setup

This repository contains Terraform code to set up a Tailscale subnet router on AWS, using a VPC, public and private EC2 instances, and security groups for secure access.

## Architecture Overview

- **Region**: US-West-2
- **Components**:
  - Public EC2 Instance: Acts as the Tailscale subnet router.
  - Private EC2 Instance: Connects through Tailscale. Could be hosting a database, media server or other in a more complex setup
  - Security Groups: Configured to allow SSH and Tailscale traffic.

## Requirements

- Terraform >= 1.3.0
- AWS Account

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/swily/TS_TH.git
cd TH_TS

```
from here follow standard Terraform deployment commands.

Note: The AMI images are not publicly available but rather images created from the EC2 instances I used, you may need to specify public AMI images when attempting to run
