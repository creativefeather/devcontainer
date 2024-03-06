$script:platform = "linux/amd64"

# Build base image
$script:base_tag = "base:bullseye-20240211-slim"
$script:base_dockerfile = Resolve-Path '..\base\bullseye.base.Dockerfile'

docker buildx build `
    --platform $script:platform `
    --tag $script:base_tag `
    --file $script:base_dockerfile `
    .


# Build nodejs image
$script:nodejs_version = "20.11.1"
$script:nodejs_tag = "nodejs:$script:nodejs_version"
$script:nodejs_dockerfile = "nodejs.${script:nodejs_version}.Dockerfile"

docker buildx build `
    --platform $script:platform `
    --tag $script:nodejs_tag `
    --file $script:nodejs_dockerfile `
    .