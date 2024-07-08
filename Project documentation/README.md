
# Project Overview

This project consists of four microservices that work together to handle user authentication, file uploads, video-to-audio conversion, and email notifications. Below is a detailed explanation of each microservice and their collaboration.

## Microservices

### 1. Auth-Service

**Purpose**: 
Handles user authentication by providing endpoints for user login and JWT validation.

**Components**:
- **Flask**: Web framework for handling HTTP requests.
- **psycopg2**: PostgreSQL database adapter.
- **jwt**: JSON Web Token library for creating and validating tokens.

**Endpoints**:
- **`/login`**: Validates user credentials and returns a JWT.
- **`/validate`**: Validates a provided JWT.

**Workflow**:
1. User sends a login request to the Gateway-Service.
2. Gateway-Service forwards the request to Auth-Service.
3. Auth-Service validates credentials against the PostgreSQL database.
4. If valid, Auth-Service generates a JWT and returns it to Gateway-Service.

### 2. Converter-Service

**Purpose**: 
Converts uploaded video files to MP3 format and stores the converted files.

**Components**:
- **pika**: Library for connecting to RabbitMQ.
- **pymongo**: MongoDB client.
- **gridfs**: MongoDB file storage system.

**Workflow**:
1. Listens for messages from RabbitMQ indicating a new video file upload.
2. Converts the video file to MP3 format.
3. Stores the MP3 file in MongoDB.

### 3. Gateway-Service

**Purpose**: 
Acts as the core entry point for the application, handling user requests for login, file upload, and file download.

**Components**:
- **Flask**: Web framework for handling HTTP requests.
- **pika**: Library for connecting to RabbitMQ.
- **flask_pymongo**: MongoDB client for Flask.
- **gridfs**: MongoDB file storage system.

**Endpoints**:
- **`/login`**: Forwards login requests to Auth-Service and returns the JWT.
- **`/upload`**: Handles video file uploads, stores them in MongoDB, and notifies Converter-Service via RabbitMQ.
- **`/download`**: Handles MP3 file download requests, retrieves files from MongoDB, and serves them to the user.

**Workflow**:
1. User sends a request to Gateway-Service.
2. Gateway-Service validates JWT tokens by communicating with Auth-Service.
3. For uploads, Gateway-Service stores the video file in MongoDB and sends a message to RabbitMQ.
4. Converter-Service processes the message, converts the video to MP3, and stores the MP3 file in MongoDB.
5. For downloads, Gateway-Service retrieves the MP3 file from MongoDB and serves it to the user.



### 4. Notification-Service

**Purpose**: 
Sends email notifications after MP3 conversion is completed.

**Components**:
- **pika**: Library for connecting to RabbitMQ.

**Workflow**:
1. Listens for messages from RabbitMQ indicating a completed MP3 conversion.
2. Sends an email notification to the user.

## Inter-Service Communication

The microservices communicate efficiently through the following mechanisms:

- **HTTP Requests**: Gateway-Service uses HTTP requests to communicate with Auth-Service for user authentication and JWT validation.
- **RabbitMQ**: Used as a message broker to facilitate communication between Gateway-Service, Converter-Service, and Notification-Service.
  - **Video Queue**: Gateway-Service sends messages to this queue to notify Converter-Service of new video uploads.
  - **MP3 Queue**: Converter-Service sends messages to this queue to notify Notification-Service of completed MP3 conversions.
- **MongoDB**: Used by Gateway-Service and Converter-Service to store and retrieve video and MP3 files.
- **PostgreSQL**: Used by Auth-Service to store and verify user credentials.

## Diagram

The architecture diagram below illustrates the interaction between the microservices:

<p align="center">
  <img src="./Project documentation/ProjectArchitecture.png" width="600" title="Architecture" alt="Architecture">
</p>


## Summary

This microservices architecture ensures modularity and scalability by separating distinct functionalities into different services. Each service handles a specific aspect of the workflow, allowing them to collaborate efficiently through well-defined interfaces and communication mechanisms.

- **Auth-Service** handles authentication and JWT management.
- **Converter-Service** manages the video-to-MP3 conversion process.
- **Gateway-Service** serves as the entry point for user interactions, managing requests for login, uploads, and downloads.
- **Notification-Service** ensures users are notified upon successful MP3 conversion.

By leveraging HTTP, RabbitMQ, and MongoDB, the system ensures robust and efficient communication and data handling, providing a seamless user experience.
