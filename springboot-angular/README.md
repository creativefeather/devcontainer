# Compose Up

```
docker compose --file .\springboot.angular.compose.dev.yml up -d
```

# Files

## _**springboot.angular.build.ps1**_

Builds the images for dev and prod needed by Springboot + Angular + MySQL

### TODO

[ ] This file is out of sync with what _**springboot.angular.dev.compose.yml**_
is expecting for its base images. I'm no longer trying to have one image for the
backend and the angular frontend.
