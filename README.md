DevOps Challenge

## Introduction

In this git repository, there are four different applications:

1. goapp: A simple Go RESTful API server that listens on port 8080 and returns a JSON response.
2. pythonapp: A Python Websocket server that listens on port 8090 and return response.
3. webapp: A Next.JS app that uses Socket.IO to communicate with backend websocket server.
4. adminapp: A Next.JS app that uses RESTful API to communicate with backend API server.

The objective of this challenge is to successfully package these applications and deploy on Cloud infrastructure using automated processes.

## Requirements

1. The WebApp clients should not directly communicate with the backend servers (pythonapp and goapp).
2. Do not modify the source code to bypass connectivity restrictions.

## Challenges

### Challenge 1: Containerize the Applications

The objective of this challenge is to create Dockerfiles for each application and build Docker images.  You should consider size, performance and security when creating the docker images.

### Challenge 2: Create docker compose file

The objective of this challenge is to create a docker-compose file that will run all the applications in a single command.

### Challenge 3: GitHub Action Automation

The objective of this challenge is to create a GitHub Action that will build the Docker images and push them to a container registry.  To avoid trigger the actual execution of these actions, you can put the github action yaml in `github/workflows` directory, instead of `.github/workflows`.

### Challenge 4: Infrastructure as Code

The objective of this challenge is to create a Terraform script that will deploy the applications on a cloud infrastructure.  You can choose AWS ECS or GCP Run.  You should consider security, scalability and cost when creating the infrastructure.

### Challenge 5: CI/CD Pipeline

Update your GitHub Action to deploy the applications on the cloud infrastructure after building the Docker images.

### Challenge 6: Monitoring

The objective of this challenge is to create a monitoring solution for the applications.  You can use any monitoring tool of your choice.

### Challenge 7: Documentation

The objective of this challenge is to create a README.md file that will explain how to run the applications locally and how to deploy them on the cloud infrastructure.

