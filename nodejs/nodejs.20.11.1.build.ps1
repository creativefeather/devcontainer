using module '../BuildHelpers.psm1'

param ([hashtable]$Spec)
$nodejs_spec = [BuildSpec]::fromHashtable($Spec)

# TODO: How can this be handled, or can it, with BuildSpec?
$nodejs_version = "20.11.1"
# TODO: Reconsider having a setDefaults method, since you could set them in a constructor,
# then merge in the overrides from $Spec. Then, just use fromHashtable with these entries.
$nodejs_spec.setDefaults(@{
        # TODO: BaseImage   = The lambda that runs the base image build
        Dockerfile  = Resolve-Path (Join-Path $PSScriptRoot "nodejs.${nodejs_version}.Dockerfile")
        Name        = 'nodejs'
        Platform    = 'linux/amd64'
        Tag         = $nodejs_version
        TargetStage = 'development'
    })

# TODO: This is logic that either builds the base base image (default) or uses the provided one
# # If alternative base image is provided, ...
# (DELETED)
# TODO: Could probably make a lambda for default base image build, and
# pass it to the class to be called if BaseImage is not set.
if ($null -eq $Spec -or -not $Spec.ContainsKey("BaseImage")) {
    & (Resolve-Path (Join-Path $PSScriptRoot '../base/bullseye.base.build.ps1')) -Spec @{
        Platform    = $nodejs_spec.Platform
        TargetStage = $nodejs_spec.TargetStage
    }
    # Getting the return value from the script was horrible with a return statement.
    $nodejs_spec.BaseImage = $env:ReturnValue
}

$nodejs_spec.display()

docker buildx build `
    --platform $nodejs_spec.Platform `
    --tag $nodejs_spec.getNameTag() `
    --file $nodejs_spec.Dockerfile `
    --build-arg BASE_IMAGE=$($nodejs_spec.BaseImage) `
    .

$env:ReturnValue = $nodejs_spec.getNameTag()