using module '../BuildHelpers.psm1'

param ([hashtable]$Spec)

# $Spec = $null -ne $null ? $Spec : [BuildSpec]::new(@{
#         # TODO: How do I know what the base image will be?
#         # - Before the base image build ran and set a global variable saying what it was.
#         BaseImage   = ''
#         Name        = 'springboot-angular'
#         Platform    = -not [string]::IsNullOrWhiteSpace($Spec.Platform) ? $Platform : 'linux/amd64'
#         Tag         = $Tag
#         TargetStage = $TargetStage
#     })


# $global:platform = -not [string]::IsNullOrWhiteSpace($Platform) ? $Platform : 'linux/amd64'
# $global:target_stage = -not [string]::IsNullOrWhiteSpace($TargetStage) ? $TargetStage : 'development'
# $Tag = -not [string]::IsNullOrWhiteSpace($Tag) ? $Tag : $global:target_stage
# $global:springboot_angular_tag = "${Name}:$Tag" # DO NOT PUT AFTER DOT INCLUDES BELOW

$springboot_spec = [BuildSpec]::fromHashtable($Spec)
$springboot_spec.setDefaults(@{
        # BaseImage   = The lambda that runs the base image build
        Dockerfile  = Resolve-Path (Join-Path $PSScriptRoot "springboot.angular.Dockerfile")
        Name        = 'springboot-angular'
        Platform    = 'linux/amd64'
        Tag         = 'latest'
        TargetStage = 'development'
    })

# # Build java + mvn + nodejs
# . (Resolve-Path (Join-Path $PSScriptRoot "../java/java.21.build.ps1"))
# . (Resolve-Path (Join-Path $PSScriptRoot "../nodejs/nodejs.20.11.1.build.ps1")) `
#     -Name 'java_nodejs' `
#     -Tag $global:target_stage `
#     -BaseImage $global:java_tag

# TODO: I don't need a to override the base image really, but it would only be
# applicable to the first in the chain. The rest would just use the previous.
& (Resolve-Path (Join-Path $PSScriptRoot "../java/java.21.build.ps1"))
$next_base = $env:ReturnValue
& (Resolve-Path (Join-Path $PSScriptRoot "../nodejs/nodejs.20.11.1.build.ps1")) `
    -Spec @{
    BaseImage   = $next_base
    Name        = 'java_nodejs'
    Platform    = $springboot_spec.Platform
    Tag         = $springboot_spec.TargetStage
    TargetStage = $springboot_spec.TargetStage
}
$springboot_spec.BaseImage = $env:ReturnValue

# Write-Host "Building nodejs image ..."
# Write-Host "Platform: $global:platform"
# Write-Host "Base image: $global:nodejs_tag"
# Write-Host "Tag: $global:springboot_angular_tag"
# Write-Host "Target stage: $global:target_stage"

$springboot_spec.display()

# Add Angular
docker buildx build `
    --platform $springboot_spec.Platform `
    --tag $springboot_spec.getNameTag() `
    --file $springboot_spec.Dockerfile `
    --build-arg BASE_IMAGE=$($springboot_spec.BaseImage) `
    .

$env:ReturnValue = $springboot_spec.getNameTag()