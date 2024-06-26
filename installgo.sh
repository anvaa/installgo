#!/bin/bash

# Update Go version to install
# Find latest Go version https://go.dev/dl/
VERSION=1.22.4

# Select rpi version cpu
CPU=arm64 #raspbian(rpi) 4/5, debian arm64
#CPU=armv6l #rpi zw
#CPU=amd64
#CPU=386

echo "Installing Go$VERSION for $CPU"

## Download the latest version of Golang
echo "Downloading Go $VERSION"
wget https://dl.google.com/go/go$VERSION.linux-$CPU.tar.gz
echo "Downloading Go $VERSION completed"

## Extract the archive
echo "Extracting..."
sudo tar -C /usr/local -xzf go$VERSION.linux-$CPU.tar.gz
echo "Extraction complete"

## Detect the user's shell and add the appropriate path variables
SHELL_TYPE=$(basename "$SHELL")

if [ "$SHELL_TYPE" = "zsh" ]; then
    echo "Found ZSH shell"
    SHELL_RC=~/.zshrc
elif [ "$SHELL_TYPE" = "bash" ]; then
    echo "Found Bash shell"
    SHELL_RC=~/.bashrc
else
    echo "Unsupported shell: $SHELL_TYPE"
    exit 1
fi

echo 'export GOPATH=$HOME/go' >> "$SHELL_RC"
echo 'export PATH=/usr/local/go/bin:$PATH' >> "$SHELL_RC"
echo 'export PATH=$HOME/go/bin:$PATH' >> "$SHELL_RC"
source $SHELL_RC

## Verify the installation
if [ -x "$(command -v go)" ]; then
    INSTALLED_VERSION=$(go version | awk '{print $3}')
    if [ "$INSTALLED_VERSION" == "go$VERSION" ]; then
        echo "Go $VERSION is installed successfully."
    else
        echo "Installed Go version ($INSTALLED_VERSION) doesn't match the expected version (go$VERSION)."
    fi
else
    echo "Go is not found in the PATH. Make sure to add Go's bin directory to your PATH."
fi

## Clean up
rm go$VERSION.linux-$CPU.tar.gz
