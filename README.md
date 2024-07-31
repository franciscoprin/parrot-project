## Description

This repository is a take-home project. It currently has two subfolders for practicality, but in reality, each of these folders should be its own repository.

The `infrastructure` folder contains a monorepo structure that will be responsible for creating the entire architecture (VPC, EKS, etc.) for the applications.

```mermaid
graph TD
  subgraph GitHub
    GA[GitHub Actions Workflow]
  end

  subgraph Internet
  end

  subgraph AWS
    subgraph Region - us-east-1
      subgraph VPC[VPC - 10.111.0.0/16]
        subgraph EKS[EKS Cluster]
        end

        subgraph AZ - us-east-1a
          subgraph PUB1[Public Subnet - 10.111.96.0/19]
            NAT1[NAT Gateway]
          end
          subgraph PVT1[Private Subnet - 10.111.0.0/19]
            subgraph EKS_NODE_GROUP_A[EKS Node Group]
              subgraph EC2_NODE_GROUP_A[EC2 - t3.medioun]
                EBS1_ATTACHED_VOLUME[dev/xvda]
              end
            end
          end
          EBS1[EBS - gp3]
        end

        subgraph AZ - us-east-1b
          subgraph PUB2[Public Subnet - 10.111.128.0/19]
            NAT2[NAT Gateway]
          end
          subgraph PVT2[Private Subnet - 10.111.32.0/19]
            subgraph EKS_NODE_GROUP_B[EKS Node Group]
              subgraph EC2_NODE_GROUP_B[EC2 - t3.medioun]
                EBS2_ATTACHED_VOLUME[dev/xvda]
              end
            end
          end
          EBS2[EBS - gp3]
        end

        subgraph AZ - us-east-1c
          subgraph PUB3[Public Subnet - 10.111.160.0/19]
            NAT3[NAT Gateway]
          end
          subgraph PVT3[Private Subnet - 10.111.64.0/19]
            subgraph EKS_NODE_GROUP_C[EKS Node Group]
              subgraph EC2_NODE_GROUP_C[EC2 - t3.medioun]
                EBS3_ATTACHED_VOLUME[dev/xvda]
              end
            end
          end
          EBS3[EBS - gp3]
        end

        IGW[Internet Gateway]
        RT_PUB1[Route Table]
        RT_PVT1[Route Table]
        RT_PVT2[Route Table]
        RT_PVT3[Route Table]

      end

      ECR[ECR Repository]
    end
    OIDC[OIDC Provider]
    IAM[IAM Role]
  end

  EBS1_ATTACHED_VOLUME <-->|attached volume| EBS1
  EBS2_ATTACHED_VOLUME <-->|attached volume| EBS2
  EBS3_ATTACHED_VOLUME <-->|attached volume| EBS3
  GA -->|assumes role via| OIDC
  OIDC -->|grants access| IAM
  IAM -->|has permissions| ECR
  GA -->|pushes images to| ECR

  PUB1 <--> RT_PUB1
  PUB2 <--> RT_PUB1
  PUB3 <--> RT_PUB1
  RT_PUB1 <--> IGW

  PVT1 --> RT_PVT1 --> NAT1
  PVT2 --> RT_PVT2 --> NAT2
  PVT3 --> RT_PVT3 --> NAT3

  NAT1 --> IGW
  NAT2 --> IGW
  NAT3 --> IGW

  IGW <--> Internet

  EKS -->|manages| EKS_NODE_GROUP_A
  EKS -->|manages| EKS_NODE_GROUP_B
  EKS -->|manages| EKS_NODE_GROUP_C
```

## Getting Started

The Geodesic container is a pre-built Docker image with essential development tools to help you set up quickly. It includes `kubectl`, `aws-cli`, and more. To install it, simply navigate to the `infrastructure` folder and run `make all`. After that, you only need to run `parrot` in your terminal.


### Getting authenticate with AWS
It is recommended to use [Leapp](https://www.leapp.cloud/download/desktop-app) for authenticating with AWS.

### Setting Up Your EKS Context
Configure your Kubernetes context to interact with your Amazon EKS cluster, this could be done inside of the geodesic container:

```bash
aws eks update-kubeconfig --region us-east-1 --name ue1-experiments-eks-cluster --profile experiments-admin
```

### Port-Forwarding an Application

Configure your Kubernetes context to interact with your Amazon EKS cluster. This can be done inside the Geodesic container:

```bash
kubectl port-forward service/challenge-devops-spoton-monochart 8080:default
```

Access the application at [http://localhost:8080](http://localhost:8080).

## Tech Stack:
* **Docker** [ ]
* **CLOUD(AWS):**
  * IAM  [ ]
    * Identity Provider (oidc) [ ]
  * EKS [ ]
  * VPC [ ]
  * Subnet [ ]
  * Internet Gateway [ ]
  * RDS [ ]
  * ECR [ ]
  * ALB [ ]
* **CI/CD:**
  * GitHub Actions [ ]
