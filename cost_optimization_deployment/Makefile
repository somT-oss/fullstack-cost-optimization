INSTANCE_ID := i-xxxxxxxxxxxxxx
REGION := us-east-1
SSM_BUCKET_URL=s3://your-ssm-bucket

.PHONY: configure-db


upload-db-script-to-s3:
	@echo "Uploading db config script to s3"
	aws s3 cp config_db.sh $(SSM_BUCKET_URL)

upload-ec2-script-to-s3:
	@echo "Uploading ec2 config script to s3"
	aws s3 cp configure_ec2.sh $(SSM_BUCKET_URL)

configure-db:
	@echo "Running DB configuration on EC2 instance $(INSTANCE_ID) via SSM..."
	aws ssm send-command \
		--instance-ids "$(INSTANCE_ID)" \
		--document-name "AWS-RunShellScript" \
		--comment "Configure PostgreSQL DB" \
		--region $(REGION) \
		--parameters '{"commands":["command -v aws >/dev/null 2>&1 || sudo snap install aws-cli --classic", "aws s3 cp s3://your-ssm-bucket/config_db.sh /tmp/config_db.sh && bash /tmp/config_db.sh "]}'


delete-db:
	@echo "Deleting the db in the server"
	aws ssm send-command \
		--instance-ids "$(INSTANCE_ID)" \
		--document-name "AWS-RunShellScript" \
		--comment "Delete the books_db" \
		--region $(REGION) \
		--parameters '{"commands": ["sudo -u postgres psql -c \"DROP DATABASE books_db;\""]}'
	
delete-role:
	@echo "Deleting the role in the server"
	aws ssm send-command \
		--instance-ids "$(INSTANCE_ID)" \
		--document-name "AWS-RunShellScript" \
		--comment "Delete the role" \
		--region $(REGION) \
		--parameters '{"commands": ["sudo -u postgres psql -c \"DROP USER real_books_admin;\""]}'
	

run-dev:
	@echo "Running the server"
	aws ssm send-command \
		--instance-ids "$(NODE_SERVER_ID)" \
		--document-name "AWS-RunShellScript" \
		--comment "Run server" \
		--region $(REGION) \
		--parameters '{"commands": ["command -v aws >/dev/null 2>&1 || sudo snap install aws-cli --classic", "aws s3 cp s3://your-ssm-bucket/configure_ec2.sh /tmp/configure_ec2.sh && bash /tmp/configure_ec2.sh "]}'