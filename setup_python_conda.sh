#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to add a line to a file if it doesn't exist
add_to_file_if_not_exists() {
    grep -qxF "$1" "$2" || echo "$1" >> "$2"
}

# Determine shell configuration file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bash_profile"
else
    echo "Unsupported shell. Please manually add paths to your shell configuration file."
    exit 1
fi

# Install or update Homebrew
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $SHELL_RC
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Updating Homebrew..."
    brew update
fi

# Install or update Python
if ! command_exists python3; then
    echo "Installing Python..."
    brew install python
else
    echo "Updating Python..."
    brew upgrade python
fi

# Install or update Miniconda
MINICONDA_PATH="$HOME/miniconda3"
if [ ! -d "$MINICONDA_PATH" ]; then
    echo "Installing Miniconda..."
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
    bash Miniconda3-latest-MacOSX-arm64.sh -b -p $MINICONDA_PATH
    rm Miniconda3-latest-MacOSX-arm64.sh
    $MINICONDA_PATH/bin/conda init "$(basename $SHELL)"
else
    echo "Updating Miniconda..."
    $MINICONDA_PATH/bin/conda update -n base -c defaults conda -y
fi

# Ensure Conda is in PATH
add_to_file_if_not_exists 'export PATH="$HOME/miniconda3/bin:$PATH"' $SHELL_RC

# Install or update Node.js
if ! command_exists node; then
    echo "Installing Node.js..."
    brew install node
else
    echo "Updating Node.js..."
    brew upgrade node
fi

# Install or update NestJS
if ! command_exists nest; then
    echo "Installing NestJS..."
    npm install -g @nestjs/cli
else
    echo "Updating NestJS..."
    npm update -g @nestjs/cli
fi

# Install or update Docker
if ! command_exists docker; then
    echo "Installing Docker..."
    brew install --cask docker
else
    echo "Docker is already installed. Please update it manually if needed."
fi

echo "Installation and updates complete. Please run 'source $SHELL_RC' or restart your terminal to apply all changes."
echo "You may need to start Docker manually after installation."