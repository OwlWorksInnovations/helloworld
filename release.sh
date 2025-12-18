#!/bin/bash
set -euo pipefail

# Get script directory (project root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"
OUTPUT_DIR="${SCRIPT_DIR}/helloworld"

echo "Setting up build environment..."
# Check if PSPDEV is set
if [ -z "${PSPDEV:-}" ]; then
    echo "Error: PSPDEV environment variable is not set."
    echo "Please install the PSP toolchain and set PSPDEV to point to it."
    exit 1
fi

# Create build directory if it doesn't exist
if [ ! -d "$BUILD_DIR" ]; then
    echo "Creating build directory..."
    mkdir -p "$BUILD_DIR"
fi

# Configure with CMake if not already configured
if [ ! -f "$BUILD_DIR/Makefile" ]; then
    echo "Configuring project with PSP toolchain..."
    cd "$BUILD_DIR"
    cmake -DCMAKE_TOOLCHAIN_FILE="$PSPDEV/psp/share/pspdev.cmake" ..
else
    cd "$BUILD_DIR"
fi

echo "Building release..."
make clean && make

echo "Copying files to output directory..."
mkdir -p "$OUTPUT_DIR"
cp "$BUILD_DIR/EBOOT.PBP" "$OUTPUT_DIR/"

# Copy font from project root directory
if [ -f "$SCRIPT_DIR/Orbitron-Regular.ttf" ]; then
    cp "$SCRIPT_DIR/Orbitron-Regular.ttf" "$OUTPUT_DIR/"
else
    echo "Warning: Font file not found at $SCRIPT_DIR/Orbitron-Regular.ttf"
fi

echo "Release build complete!"
echo "Output directory: $OUTPUT_DIR"

