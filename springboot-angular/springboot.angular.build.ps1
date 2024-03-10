using module '../BuildHelpers.psm1'

param ([hashtable]$Spec)

$springboot_spec = [BuildSpec]::fromHashtable($Spec)
$springboot_spec.setDefaults(@{
        # TODO: BaseImage   = The lambda that runs the base image build
        Dockerfile  = Resolve-Path (Join-Path $PSScriptRoot "springboot.angular.Dockerfile")
        Name        = 'springboot-angular'
        Platform    = 'linux/amd64'
        Tag         = 'latest'
        TargetStage = 'development'
    })

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

$springboot_spec.display()

# Add Angular
docker buildx build `
    --platform $springboot_spec.Platform `
    --tag $springboot_spec.getNameTag() `
    --file $springboot_spec.Dockerfile `
    --build-arg BASE_IMAGE=$($springboot_spec.BaseImage) `
    .

$env:ReturnValue = $springboot_spec.getNameTag()