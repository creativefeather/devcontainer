using module '../BuildHelpers.psm1'

param ([hashtable]$Spec)

Import-Module (Resolve-Path (Join-Path $PSScriptRoot "../BuildHelpers.psm1"))

# TODO: Complete registry and manifest code
# $REGISTRY_HOST = "pi-cluster-1:5000"
$AMD64_URL = "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz"
$ARM64_URL = "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-aarch64_bin.tar.gz"

$imageList = New-Object System.Collections.ArrayList

$java_spec = [BuildSpec]::fromHashtable($Spec)
$java_spec.setDefaults(@{
        # TODO: BaseImage   = The lambda that runs the base image build
        Dockerfile  = Resolve-Path (Join-Path $PSScriptRoot "java.21.bullseye.Dockerfile")
        Name        = 'java-maven'
        Platform    = 'linux/amd64'
        Tag         = 'openjdk-21'
        TargetStage = 'development'
    })

# TODO: Move repeated logic into BuildSpec class
if ($null -eq $Spec -or -not $Spec.ContainsKey("BaseImage")) {
    & (Resolve-Path (Join-Path $PSScriptRoot '../base/bullseye.base.build.ps1')) -Spec @{
        Platform    = $java_spec.Platform
        TargetStage = $java_spec.TargetStage
    }
    # Getting the return value from the script was horrible with a return statement.
    $java_spec.BaseImage = $env:ReturnValue
}

# TODO: This hints at needing some way to supply different build arguments based
# - on the platform. OR actualy, different specs for different platforms.
foreach ($platform in $java_spec.Platform -split ",") {
    switch ($platform) {
        "linux/amd64" {
            $java_spec.Tag = "amd64"
            $imageList.Add($java_spec.getNameTag())

            $java_spec.display()

            docker buildx build `
                --platform $platform `
                --build-arg JAVA_DOWNLOAD_URL=$AMD64_URL `
                --build-arg BASE_IMAGE=$($java_spec.BaseImage) `
                -t $java_spec.getNameTag() `
                -f $java_spec.Dockerfile `
                .
        }
        "linux/arm64" {
            $java_spec.Tag = "arm64"
            $imageList.Add($java_spec.getNameTag())

            $java_spec.display()

            docker --context=pi-cluster-1 buildx build `
                --platform $platform `
                --builder pi-cluster-1 `
                --build-arg JAVA_DOWNLOAD_URL=$ARM64_URL `
                --build-arg BASE_IMAGE=$($java_spec.BaseImage) `
                -t $java_spec.getNameTag() `
                -f $java_spec.Dockerfile `
                --load `
                .
        }
        Default {
            Write-Host "Unsupported platform: $platform"
            continue
        }
    }
}

# TODO: Create code for manifest list and push to registry
### Manifest List ###
# if (Prompt-YesNo "Do you want to create a manifest list? (yes/no)") {
#     Write-Host "Creating manifest list for $name ..."
#     $manifest_name = New-ManifestList `
#         -manifest_name $NAME `
#         -image_list $image_list `
#         -registry_host $REGISTRY_HOST
# }
# else { Write-Host "Manifest list creation for $name skipped!" }

# if ($null -ne $manifest_name -and (Prompt-YesNo "Do you want to push the manifest list to a Docker registry? (yes/no)")) {
#     Write-Host "Pushing $manifest_name to registry..."
#     docker manifest push $manifest_name
# }
# else { Write-Host "Manifest push for $name skipped!" }

$env:ReturnValue = $java_spec.getNameTag()