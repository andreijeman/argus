#!/bin/bash

echo "Starting services..."

# === CONFIG ===
BACKEND_PATH="./argus-server/src/Argus.Api"
FRONTEND_PATH="./argus-web"
DOCKER_CONTAINER_NAME="postgres"
LIVEKIT_SCRIPT="run-livekit.sh"

# === Start ASP.NET Core API ===
echo "Starting ASP.NET Core API..."
(
    cd "$BACKEND_PATH" || exit
    dotnet run
) &
BACKEND_PID=$!

# === Start React App ===
echo "Starting React App..."
(
    cd "$FRONTEND_PATH" || exit
    npm run dev
) &
FRONTEND_PID=$!

# === Start Tailscale ===
echo "Starting Tailscale..."
sudo tailscale up

# === Start Docker Container ===
echo "Starting Docker container: $DOCKER_CONTAINER_NAME"
docker start "$DOCKER_CONTAINER_NAME"

# === Run LiveKit Script ===
if [ -f "$LIVEKIT_SCRIPT" ]; then
    echo "Starting LiveKit..."
    bash "$LIVEKIT_SCRIPT" &
    LIVEKIT_PID=$!
else
    echo "LiveKit script not found: $LIVEKIT_SCRIPT"
fi

echo "All services started!"
echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"
[ -n "$LIVEKIT_PID" ] && echo "LiveKit PID: $LIVEKIT_PID"

# Optional: Wait for all background processes
wait
