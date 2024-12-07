#!/bin/bash

set -e  # Exit immediately if a command fails

# Update and install essential tools
echo "Updating package lists and installing essential tools..."
sudo apt-get update
sudo apt-get install -y build-essential git ssh

# Configure SSH
SSH_KEY_PATH="$HOME/.ssh/retspan_key"
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""
    echo "SSH key generated at $SSH_KEY_PATH"
else
    echo "SSH key already exists at $SSH_KEY_PATH"
fi

# Start SSH agent and add key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY_PATH"

# Display public key for GitLab configuration
echo "Add the following SSH public key to your GitLab account:"
cat "${SSH_KEY_PATH}.pub"

read -p "Press Enter after adding the SSH key to GitLab to continue..."

# Clone repository
REPO_URL="ist-git@git.uwaterloo.ca:edumper/retspan-linux.git"
REPO_DIR="retspan-linux"
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$REPO_DIR"
else
    echo "Repository already cloned."
fi

# Run the repository's setup script
echo "Navigating to repository and running setup script..."
cd "$REPO_DIR"
chmod +x setup_env.sh
./setup_env.sh

echo "Setup completed successfully!"

