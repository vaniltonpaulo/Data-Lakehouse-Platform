# Data-Lakehouse-Platform
Production-grade data lakehouse on AWS, provisioned end-to-end with Terraform and other tools. 


# Log Progress

### Infrastructure as Code

Goal: Provisioned all cloud resources using Terraform with reusable modules and remote state management.

### Remote Terraform State

Configured Terraform backend using:

- Amazon S3 for state storage
- DynamoDB for state locking

This prevents concurrent state corruption.
It also on Terraform web page. Just some best practices

### Data Lake Storage Layer

Created a medallion-style storage  with three S3 buckets:

- Bronze → raw ingested data
- Silver → cleaned / transformed data -> This could be for ML/AI work
- Gold → analytics-ready data -> Businees data

Implemented:

- Bucket versioning
- Public access blocking
- Lifecycle policy to archive Bronze data to Glacier after 90 days.

### IAM Security

Created least-privilege IAM role and policy for Lambda ingestion.
Least privilege is the way to go!!!

Permissions include:

- Write objects to Bronze bucket
- Write logs to CloudWatch

### Serverless Ingestion

Built an AWS Lambda ingestion service in Python(Just copy and paste from a AWS doc).

The function:

- Accepts event payloads
- Generates partitioned paths by date
- Writes JSON data into Bronze bucket

Log message: Need to take a break. come back after a 1 hour or so
### To do still

- EventBridge scheduler for automated ingestion
- SQS dead-letter queue
- AWS Glue ETL jobs
- Redshift Serverless
- dbt transformations
- Monitoring / alerts
- GitHub Actions CI/CD
