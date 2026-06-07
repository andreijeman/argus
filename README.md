# ARGUS — Turn your smartphone into an IP camera

## Running the System on Linux

## 1. Running the Database in Docker

```bash
sudo docker pull postgres:latest

docker run --name argus-postgres -e POSTGRES_PASSWORD=password -d -p 5432:5432 postgres
```

## 2. Applying Database Migrations

```bash
cd argus-server/src/Argus.Persistence

dotnet ef database update -s '../Argus.Api'
```

## 3. Running the Tailscale VPN

On the mobile device, Tailscale is started through the UI interface, while on the PC it is started using the following command:

```bash
sudo tailscale up
```

## 4. Running the LiveKit Media Server

The system uses the LiveKit Media Server for real-time video and audio communication between devices. 
LiveKit must be installed ([docs](https://docs.livekit.io/home/self-hosting/local/)) and started locally:

```bash
bash run-livekit.sh
```

## 5. Running the System Components

The mobile application must be built and launched through Android Studio.
The other applications can be started using the following commands:

```bash
cd argus-server/src/Argus.Api
dotnet run
```

```bash
cd argus-web
npm run dev
```
