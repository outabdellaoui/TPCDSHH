param (
    [string]$DockerUser,
    [string]$DockerToken
)

# Se connecter à Docker Hub
Write-Host "Logging into Docker Hub..."
docker login -u $DockerUser -p $DockerToken

# Arrêter et supprimer l'ancien conteneur s'il existe
$containerName = "flask-app"
if (docker ps -a --format "{{.Names}}" | Select-String -Pattern "^$containerName$") {
    Write-Host "Stopping and removing existing container..."
    docker stop $containerName
    docker rm $containerName
}

# Pull l'image fraîche
$imageName = "$DockerUser/flask-app:latest"
Write-Host "Pulling image $imageName..."
docker pull $imageName

# Lancer le nouveau conteneur
Write-Host "Starting new container..."
docker run -d --name $containerName -p 5000:5000 --restart unless-stopped $imageName

Write-Host "Deployment completed."