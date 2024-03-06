. "./build-helpers.ps1"

$NAME = "java-maven"
$DOCKERFILE = "java-21-bullseye.Dockerfile"
$REGISTRY_HOST = "pi-cluster-1:5000"
$AMD64_URL = "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
$ARM64_URL = "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-aarch64_bin.tar.gz"

$imageList = New-Object System.Collections.ArrayList

# Use Docker Buildx to build for Linux/amd64 architecture
$AMD64_TAG = $NAME + ":amd64"
$imageList.Add($AMD64_TAG)

docker buildx build `
    --platform linux/amd64 `
    --build-arg JAVA_DOWNLOAD_URL=$AMD64_URL `
    -t $AMD64_TAG `
    -f $DOCKERFILE `
    .

# Use Docker Buildx to build for Linux/arm64 architecture
$ARM64_TAG = $NAME + ":arm64"
$imageList.Add($ARM64_TAG)

docker --context=pi-cluster-1 buildx build `
    --platform linux/arm64 `
    --builder pi-cluster-1 `
    --build-arg JAVA_DOWNLOAD_URL=$ARM64_URL `
    -t $ARM64_TAG `
    -f $DOCKERFILE `
    --load `
    .

if (Prompt-YesNo "Do you want to create a manifest list? (yes/no)") {
    Write-Host "Creating manifest list for $name ..."
    $manifest_name = New-ManifestList `
        -manifest_name $NAME `
        -image_list $image_list `
        -registry_host $REGISTRY_HOST
}
else { Write-Host "Manifest list creation for $name skipped!" }

if ($null -ne $manifest_name -and (Prompt-YesNo "Do you want to push the manifest list to a Docker registry? (yes/no)")) {
    Write-Host "Pushing $manifest_name to registry..."
    docker manifest push $manifest_name
}
else { Write-Host "Manifest push for $name skipped!" }