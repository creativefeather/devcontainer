using module '../BuildHelpers.psm1'

# param (
#     [string]$Platform,
#     [string]$TargetStage,
#     [string]$BaseImage
# )

param ([hashtable]$Spec)

$base_spec = [BuildSpec]::fromHashtable($Spec)
$base_spec.setDefaults(@{
        BaseImage   = 'debian:bullseye-20240211-slim'
        Dockerfile  = Resolve-Path (Join-Path $PSScriptRoot './bullseye.base.Dockerfile')
        Name        = 'base-dev'
        Platform    = 'linux/amd64'
        Tag         = 'latest'
        TargetStage = 'development'
    })

# $global:platform = -not [string]::IsNullOrWhiteSpace($Platform) ? $Platform : 'linux/amd64'
# $global:target_stage = -not [string]::IsNullOrWhiteSpace($TargetStage) ? $TargetStage : 'development'
# $global:base_image = -not [string]::IsNullOrWhiteSpace($BaseImage) ? $BaseImage : 'debian:bullseye-20240211-slim'

# TODO: Here I was trying to change the name depending on the target stage
# if ($global:target_stage -eq 'development') {
#     $global:base_tag = 'base-dev:bullseye-20240211-slim'
# }
# else {
#     throw "Invalid base target stage specified: $global:target_stage"
# }

# $base_dockerfile = Resolve-Path (Join-Path $PSScriptRoot './bullseye.base.Dockerfile')

# Write-Host "Building base image ..."
# Write-Host "Platform: $global:platform"
# Write-Host "Base image: $global:base_image"
# Write-Host "Tag: $global:base_tag"
# Write-Host "Target stage: $global:target_stage"

$base_spec.display()

docker buildx build `
    --platform $base_spec.Platform `
    --target $base_spec.TargetStage `
    --tag $base_spec.getNameTag() `
    --build-arg BASE_IMAGE=$($base_spec.BaseImage) `
    --file $base_spec.Dockerfile `
    .

$env:ReturnValue = $base_spec.getNameTag()