# Infrastructure as Code for an Online Store on AWS with Terraform

## Description

This project implements a complete infrastructure on **Amazon Web Services (AWS)** for an **online store**, using **Terraform** for resource management and provisioning. The architecture is designed to be **highly available, scalable, and secure**, decoupling services to improve resilience and maintainability.

The main goal is to automate the infrastructure creation, allowing for a fast and consistent deployment across different environments.

## Architecture

The architecture is divided into two main parts: the resources within the **VPC (Virtual Private Cloud)** and the AWS services not linked to the VPC.

### VPC


The VPC is designed with public and private subnets to isolate resources and enhance security:

* **Public Subnet**: Contains the **Application Load Balancer (ALB)**, which acts as the entry point for web traffic and distributes it among the EC2 instances.
* **Private Subnet**: Hosts the **EC2 instances** that run the web application. These instances are not directly accessible from the Internet, which increases security.
* **Database Subnet**: Contains the **Amazon RDS (MySQL)** instance, ensuring that the database is isolated and not accessible from the outside.

### AWS Services

The interaction between the different AWS services is shown in the following diagram:

* **Users**: Interact with the institutional website (hosted in an S3 bucket) and the online store (through the ALB).
* **EC2 Instances**: Run the web service and assume IAM roles to securely interact with other AWS services.
* **IAM Roles**: Define the permissions for EC2 instances to access S3 buckets and other resources.
* **Amazon S3 Buckets**:
    * **Institutional Web Page**: Stores the static content of the institutional website.
    * **Product Metadata Bucket**: Saves product information and metadata for the store.
    * **Order Storage Bucket**: Stores provider orders, which are then processed automatically.
* **AWS Lambda**: Is triggered when a new order is uploaded to the *Order Storage Bucket*, processes the order, and sends it to an SQS queue.
* **Amazon SQS and SNS**: Manage order processing queues and the decoupled sending of notifications to customers.
* **Amazon CloudWatch**: Centralizes logs and metrics from all services for application monitoring and observability.

## Features

* **High Availability and Scalability**: The use of an **Application Load Balancer** and multiple **EC2 instances** distributed across different availability zones ensures that the application is fault-tolerant and can scale horizontally according to demand.
* **Security**: The infrastructure follows security best practices, such as using **private subnets** for EC2 instances and the database, and managing permissions through **IAM roles**.
* **Service Decoupling**: **Amazon SQS and SNS** are used to decouple the notification and messaging system, ensuring reliable and asynchronous delivery without affecting the web application's performance.
* **Automatic Order Processing**: The order processing workflow is fully automatic, using **S3 Events, Lambda, and SQS** to process orders without manual intervention.
* **Centralized Monitoring and Logging**: **CloudWatch** provides a centralized system for collecting and analyzing logs and metrics, making it easy to monitor the application's health and performance.
* **Infrastructure as Code**: The entire project is defined as code using **Terraform**, which allows for automation, reproducibility, and version control of the infrastructure.

## AWS Services Used

* **Amazon VPC**: To create an isolated and secure network in the cloud.
* **Amazon EC2**: To run the online store application.
* **Amazon RDS**: As a managed relational database (MySQL).
* **Application Load Balancer (ELB)**: To distribute incoming traffic.
* **Amazon S3**: For object storage, such as the static website, product metadata, and orders.
* **AWS Lambda**: To run serverless code in response to events.
* **Amazon SQS**: As a message queueing service.
* **Amazon SNS**: For sending notifications.
* **Amazon CloudWatch**: For monitoring and log collection.
* **AWS IAM**: For identity and access management.

## Prerequisites

* [Terraform](https://www.terraform.io/downloads.html) installed.
* AWS credentials configured.

## How to Use

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/your-user/your-repository.git](https://github.com/your-user/your-repository.git)
    cd your-repository
    ```

2.  **Configure your AWS profile:**

    Open the `variables.tf` file and change the value of the `aws_profile` variable to your AWS profile.

    ```hcl
    variable "aws_profile" {
      description = "The AWS profile to use"
      type        = string
      default     = "your-aws-profile" # Change this
    }
    ```

3.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

4.  **Review the execution plan:**

    ```bash
    terraform plan
    ```

5.  **Apply the changes and deploy the infrastructure:**

    ```bash
    terraform apply
    ```

6.  **To destroy the infrastructure:**

    ```bash
    terraform destroy
    ```
