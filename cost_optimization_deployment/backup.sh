#!/bin/bash
# Exit immediately if a command fails
set -e

# === CONFIGURATION ===
DB_NAME=""
DB_USER=""
S3_BUCKET=""
BACKUP_PATH="/tmp"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
DUMP_FILE="$BACKUP_PATH/${DB_NAME}_$DATE.sql.gz"

# === RUN BACKUP ===
echo "[$(date)] Starting backup of $DB_NAME..."

# Dump and compress (no -h since we are local)
PGPASSWORD="<db-password>" pg_dump -h localhost -U $DB_USER $DB_NAME | gzip > "$DUMP_FILE"


echo "[$(date)] Backup created at $DUMP_FILE"

# Upload to S3
aws s3 cp "$DUMP_FILE" "s3://$S3_BUCKET/backups/"

echo "[$(date)] Backup uploaded to s3://$S3_BUCKET/backups/"

# Clean up local file
rm -f "$DUMP_FILE"
echo "[$(date)] Local backup file removed"