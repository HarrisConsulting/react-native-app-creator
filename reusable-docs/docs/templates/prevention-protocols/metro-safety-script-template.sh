#!/bin/bash

# Metro Start Protocol for ReactNativeTest
# This script ensures Metro ALWAYS starts from the correct project directory

PROJECT_DIR="/Users/rogerharris/Projects/ReactNativeTest"

echo "🚀 Starting Metro from correct project directory..."
echo "📁 Project Directory: $PROJECT_DIR"

# Change to project directory
cd "$PROJECT_DIR" || exit 1

# Verify we're in the right place
echo "📍 Current Directory: $(pwd)"
echo "✅ Verifying index.js exists: $(ls -la index.js 2>/dev/null || echo 'NOT FOUND')"

# Kill any existing Metro processes
echo "🔄 Stopping any existing Metro processes..."
pkill -f metro 2>/dev/null || true

# Start Metro with cache reset
echo "▶️ Starting Metro with cache reset..."
npm start -- --reset-cache
