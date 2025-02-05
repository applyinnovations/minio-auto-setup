#!/bin/sh

wait_for_minio() {
    echo "Waiting for MinIO to start..."
    while ! mc alias set minio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD >/dev/null 2>&1; do
        sleep 1
    done
    echo "MinIO is up and running."
}

wait_for_minio

# Convert comma-separated list to array
IFS=',' read -ra BUCKET_ARRAY <<< "$BUCKET_NAMES"

# Function to check if a bucket should be kept
should_keep_bucket() {
    for name in "${BUCKET_ARRAY[@]}"; do
        if [ "$1" = "$name" ]; then
            return 0 # Bucket found in the list, should keep
        fi
    done
    return 1 # Bucket not found in the list, should remove
}

# Get the list of existing buckets
EXISTING_BUCKETS=""
while read -r line; do
    EXISTING_BUCKETS="$EXISTING_BUCKETS $(echo "$line" | tr -d '/' | tr -s ' ' | cut -d' ' -f5)"
done < <(mc ls minio)

# Clean up existing buckets not in BUCKET_NAMES
echo "Removing buckets not in the specified list..."
for bucket in $EXISTING_BUCKETS; do
    if ! should_keep_bucket "$bucket"; then
        echo "Removing bucket $bucket"
        if ! mc rb --force minio/$bucket; then
            echo "Failed to remove bucket $bucket."
            exit 1
        fi
    fi
done

# Create or verify buckets in BUCKET_NAMES
for BUCKET_NAME in "${BUCKET_ARRAY[@]}"; do
    # Remove any leading or trailing whitespace
    BUCKET_NAME=$(echo "$BUCKET_NAME" | tr -d '[:space:]')

    # Check if bucket exists
    bucket_exists=false
    for existing in $EXISTING_BUCKETS; do
        if [ "$existing" = "$BUCKET_NAME" ]; then
            bucket_exists=true
            break
        fi
    done

    if [ "$bucket_exists" = false ]; then
        echo "Bucket $BUCKET_NAME does not exist, attempting to create it..."
        if ! mc mb minio/$BUCKET_NAME; then
            echo "Failed to create bucket $BUCKET_NAME."
            exit 1
        fi
    else
        echo "Bucket $BUCKET_NAME already exists."
    fi
done

echo "Bucket setup and cleanup completed."
