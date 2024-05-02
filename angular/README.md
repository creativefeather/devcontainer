# Angular Version 17.2.3

#### PowerShell

```powershell
docker buildx build `
    --platform linux/amd64 `
    --tag angular:17.2.3 `
    --file angular.dev.Dockerfile `
    --build-arg ANGULAR_VERSION=17.2.3 `
    .
```

#### Bash

```bash
docker buildx build \
    --platform linux/amd64 \
    --tag angular:17.2.3 \
    --file angular.dev.Dockerfile \
    --build-arg ANGULAR_VERSION=17.2.3 \
    .
```
