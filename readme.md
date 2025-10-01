Three-Tier Application Deployment
=================================

This project demonstrates two different deployment strategies for a **three-tier application** consisting of:

*   **Frontend** → deployed with **CloudFront** + **S3**
    
*   **Backend** → deployed on **EC2**
    
*   **Database** → deployed on **RDS** (traditional) or **EC2** (cost-optimized)
    

📂 Project Structure
--------------------

*   **default_deployment** Contains the **traditional deployment** setup:
    
    *   Frontend on S3 + CloudFront
        
    *   Backend on EC2
        
    *   Database on RDS
        
*   **cost_optimization_deployment** Contains the **cost-saving deployment** setup:
    
    *   Backend and Database both run on EC2
        
    *   Database is configured using **bash scripts + AWS SSM**
        
    *   Scripts are uploaded to an S3 bucket and executed remotely inside the private instances
        

⚡ Cost Optimization Deployment Workflow
---------------------------------------

1.  **Prepare S3 Bucket**
    
    *   Create a bucket to hold your **bash scripts**.
        
    *   Update **iam/main.tf** and add the bucket ARN to the s3_read_policy.
        
2.  **Update Configuration Files**
    
    *   Edit **config_db.sh**:
        
        *   Replace placeholder variables with actual values.
            
        *   Set the vpc_cidr value to match the CIDR of your current VPC.
            
    *   Edit **configure_ec2.sh**:
        
        *   Replace variables with the correct information for your environment.
            
3. **Upload Scripts to S3**  
Run the following commands to upload configuration scripts for DB and EC2: 
```
make upload-db-script-to-s3 SSM_BUCKET=
make upload-ec2-script-to-s3 SSM_BUCKET=
```
    
4. **Deploy and Configure Database**  
Run:
```
make configure-db INSTANCE_ID= REGION=
```
This uses SSM to configure the database instance with the uploaded script.

    
5.  **Deploy Backend Server**  
Run:
```
make run-dev NODE_SERVER_ID= REGION=
```
This uses SSM to configure and start the backend Node.js server on the EC2 instance.
    

🛠️ Key Features
----------------

*   Supports **two deployment models**:
    
    *   **Traditional (RDS-based)**
        
    *   **Cost-optimized (EC2-based DB)**
        
*   Automated deployments using **Make + SSM**.
    
*   Centralized storage of configuration scripts in **S3**.
    
*   Easy-to-modify scripts for custom environments.
    

🚨 Notes
--------

*   Always update the **variables** inside config_db.sh and configure_ec2.sh before pushing.
    
*   Ensure your IAM roles have the correct **S3 read permissions** to pull the scripts.
    
*   Confirm that **VPC CIDR values** match when configuring the database.
    

📌 Example Usage
----------------
```
# Upload DB and EC2 config scripts to S3  

make upload-db-script-to-s3 SSM_BUCKET=my-ssm-bucket  
make upload-ec2-script-to-s3 SSM_BUCKET=my-ssm-bucket  
```
```
# Configure the DB  
make configure-db INSTANCE_ID=i-0123456789abcdef REGION=us-east-1  
```
```
# Run the backend server  
make run-dev NODE_SERVER_ID=i-0abcdef123456789 REGION=us-east-1 
```