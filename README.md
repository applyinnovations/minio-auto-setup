# MinIO Automatic Setup

## Purpose
This repository contains a Docker image for creating an MinIO docker with environment variable configuration such that no ui configuration is required to create a list of buckets. DO NOT USE PRODUCTION AWS CREDENTIALS WITH THIS SETUP.

## Getting Started

### Prerequisites
- Docker installed on your system
- Basic understanding of Docker usage

### Build the Docker Image

To build the Docker image:
```sh
docker build .
```

### Run the Docker Container

To run the container with the necessary configurations:
```sh
    docker run \
        -p 9000:9000 \
        -p 9001:9001 \
        -e MINIO_ROOT_USER=mock_access_key \
        -e MINIO_ROOT_PASSWORD=mock_secret_key \
        -e BUCKET_NAMES="bucket1,bucket2" \
        -v /your/local/data/path:/data \
        ghcr.io/applyinnovations/minio-auto-setup:latest
```

**Explanation of Flags:**
- `-p 9000:9000`: Maps the MinIO server port.
- `-p 9001:9001`: Maps the MinIO console port for management.
- `-e MINIO_ROOT_USER`: Environment variable for the access key.
- `-e MINIO_ROOT_PASSWORD`: Environment variable for the secret key.
- `-e BUCKET_NAMES`: Comma-separated list of bucket names to initialize or maintain.
- `-v /your/local/data/path:/data`: Mounts a local directory to the container's `/data` directory for persistent storage. Replace `/your/local/data/path` with an actual path on your host machine where you want to store data.

**Note:** Replace `mock_access_key` and `mock_secret_key` with your chosen FAKE credentials, and list the bucket names without spaces between commas. DO NOT USE PRODUCTION AWS CREDENTIALS WITH THIS SETUP.

### Accessing MinIO
**S3 API**: Use `http://localhost:9000` for S3-compatible API interactions.
**MinIO Console**: Access the management console at `http://localhost:9001`. Log in with the provided `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORd`.

### Notes

**Bucket Management**: The script will create listed buckets and remove any buckets not listed in `BUCKET_NAMES`, ensuring only necessary buckets are present for testing.

### Contribution

Feel free to fork this repository and contribute enhancements or fixes. Please ensure to maintain the security and integrity of the setup when contributing.

### Credits

This project relies on [MinIO](https://min.io/), an open-source, high-performance object storage server compatible with Amazon S3. We appreciate the MinIO team's efforts in providing a robust and scalable storage solution that makes this offline S3 bucket emulation possible.

- **MinIO Project**: [min.io](https://min.io/)
- **GitHub**: [GitHub - MinIO](https://github.com/minio/minio)

### License

MIT License

Copyright (c) 2025 Apply Innovations Pty Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

