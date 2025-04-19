# Strapi-Deployment

This project containerizes a Strapi CMS application using a multi-stage Dockerfile and deploys it to an AWS EC2 instance using GitHub Actions. It uses build-time arguments to pass secrets like ADMIN_JWT_SECRET, API_TOKEN_SALT, and others, which can be securely managed through GitHub Action secrets. A short user-data script is used on the EC2 instance to generate SSH keys automatically, allowing GitHub Actions to connect and deploy the app.

## Prerequisites for running pipeline

- Settings -> actions -> general -> Workflow permissions -> Read and write permissions

- Github secrets-
    - DOCKER_HUB_TOKEN - your dockerhub token with appropraite permissions
    - PAT_TOKEN - your github personl access token with appropraite permissions
    - SSH_PRIVATE_KEY -> ssh private key generated from your instance (unbuntu user must have permission to read)
    - EC2_INSTANCE_PUBLIC_IP
    - API_TOKEN_SALT
    - ADMIN_JWT_SECRET
    - TRANSFER_TOKEN_SALT
    - APP_KEYS
    - DOCKER_HUB_USER
 
- To generate app keys- 
    ```bash
    node -e "console.log(Array(4).fill().map(() => require('crypto').randomBytes(16).toString('base64')).join(','))"
    ```

- To generate secrets
    ```bash
    node -e "console.log(require('crypto').randomBytes(16).toString('base64'))"
    ```
- To view keys
    ```bash
    cat /home/ubuntu/.ssh/my-ec2-key
    cat /home/ubuntu/.ssh/my-ec2-key.pub
    ```
    