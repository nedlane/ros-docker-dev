#!/bin/bash
# Prompt the user for directory input
echo "Enter the ABSOLUTE directory path (i.e. no instances of ./):"
read -p "" directory_path
touch .env

# Validate if the directory exists
if [ ! -d "$directory_path" ]; then
    echo "Directory does not exist."
    exit 1
fi

# Create a new .env file with the updated ROS_PROJECT_PATH
echo "ROS_PROJECT_PATH='$directory_path'" > .env

echo "Directory path added to .env file."

sudo docker pull nvidia/cuda:12.5.1-cudnn-devel-ubuntu20.04
sudo docker build .
sudo docker-compose up -d
sudo docker attach ros-dev-vm
