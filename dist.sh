#!/bin/bash
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUTPUT_DIR="${SCRIPT_DIR}/helloworld"
PSP_GAME_DIR="/media/juan/disk/PSP/GAME/helloworld"

echo "Building project..."
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory not found. Run cmake first."
    exit 1
fi

cd "$BUILD_DIR"
make clean && make

echo "Copying files to output directory..."
mkdir -p "$OUTPUT_DIR"
cp "$BUILD_DIR/EBOOT.PBP" "$OUTPUT_DIR/"
cp "$BUILD_DIR/Orbitron-Regular.ttf" "$OUTPUT_DIR/"

echo "Deploying to PSP..."
if [ -d "/media/juan/disk/PSP/GAME" ]; then
    mkdir -p "$PSP_GAME_DIR"
    cp -r "$OUTPUT_DIR"/* "$PSP_GAME_DIR/"
    echo "Successfully deployed to PSP!"
else
    echo "Warning: PSP device not mounted at /media/juan/disk"
    echo "Skipping PSP deployment."
fi

echo "Build and distribution complete!"

