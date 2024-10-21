#!/bin/bash

# Set variable
IMAGE_NAME="home-lab"
CONTAINER_NAME="home-lab-container"
DOCKERFILE_PATH="./Dockerfile"
CONTEXT_PATH="."

# Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME -f $DOCKERFILE_PATH $CONTEXT_PATH

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully."
else
    echo "Error: Docker image build failed."
    exit 1
fi

# Run the container in the background
echo "Starting container in the background..." 
#docker run -it --name $CONTAINER_NAME $IMAGE_NAME bash
docker run -it $IMAGE_NAME bash
#docker run -d --name $CONTAINER_NAME $IMAGE_NAME
#docker run --entrypoint ./setup.sh $IMAGE_NAME

# Check if the container started successfully
if [ $? -eq 0 ]; then
    echo "Container started successfully."
    echo "Container ID: $(docker ps -q -f name=$CONTAINER_NAME)"
else
    echo "Error: Failed to start the container."
    exit 1
fi
