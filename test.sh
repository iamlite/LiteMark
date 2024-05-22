#!/bin/bash

# Define variables
APP_NAME="LiteMark"
BUILD_DIR=".build/debug"
APP_BUNDLE="$APP_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
PLIST_FILE="$CONTENTS_DIR/Info.plist"

# Check if the app is running and kill it
if pgrep "$APP_NAME" > /dev/null; then
    echo "Closing the running instance of $APP_NAME..."
    pkill "$APP_NAME"
    # Wait for the process to terminate
    sleep 2
fi

# Build the project
echo "Building the project..."
swift build

# Create the app bundle structure
echo "Creating app bundle structure..."
mkdir -p "$MACOS_DIR"

# Copy the executable
echo "Copying the executable..."
cp "$BUILD_DIR/$APP_NAME" "$MACOS_DIR/"

# Create Info.plist
echo "Creating Info.plist..."
cat >"$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.$APP_NAME</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSMainNibFile</key>
    <string>MainMenu</string>
</dict>
</plist>
EOF

# Open the app
echo "Running the app..."
open "$APP_BUNDLE"
