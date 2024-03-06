# Dockerfile Best Practices

* **Base Images**
    * Use official base images
        * Best practices already applied by smart people.
    * Specify version
        * Always specify a version tag for the base image to ensure repeatability and avoid unexpected updates. Do not use "latest" tag, it is a rolling tag.
    * Regularly update
        * To incorporate security patches and updates, ensuring your images are built on the latest stable and secure versions.

* **Use LABEL for Metadata**: Adding relevant metadata.
    * LABEL maintainer="Your Name <your.email@example.com>"
    * LABEL description="This is a Docker image for running an example application."
    * LABEL version="1.0"
    * LABEL vendor="Example Corp"
    * LABEL url="https://example.com/docker-image"
    * LABEL license="MIT"
    * OCI image specifictation
        * LABEL org.opencontainers.image.title="My App"
        * LABEL org.opencontainers.image.description="An example Docker image for My App."
        * LABEL org.opencontainers.image.url="https://example.com/my-app"
        * LABEL org.opencontainers.image.vendor="Example Corp"
* **Document Your Dockerfile**: Add comments and documentation within your Dockerfile to explain the purpose of each instruction and any specific configuration choices.

* **Minimize Layers**: Use multi-stage builds and combine commands to minimize the number of layers in your image, reducing its size and improving build performance.

* **Combine RUN Instructions**: Combine multiple `RUN` instructions into a single command using `&&` to reduce the number of layers and cache invalidations.

* **Use .dockerignore**: Create a `.dockerignore` file to exclude unnecessary files and directories from the build context, reducing image size and build time.

* **Optimize Dockerfile Order**: Place frequently changing instructions (such as `COPY` or `ADD`) after less frequently changing instructions to take advantage of Docker's layer caching mechanism.

* **COPY and ADD instructions**
    * Prefer `COPY` over `ADD`
        * unless you need the additional features of `ADD`, as `COPY` is more transparent and less prone to unexpected behavior.
    * Avoid "COPY ."
        * Use more specific COPY to limit cache busts

* **Avoid Unnecessary Packages and Files**: reduces image size and potential security vulnerabilities.
    * **Avoid unnecessary packages**
        * e.g. use ***--no-install-recommends*** flag
    * **Clean up after installations**
        * remove temporary files
        * cleanup caches within same `RUN` command after installing packages
        * e.g. $ rm -rf /var/lib/apt/lists/*



* **Specify Non-Root User**: Run your application with a non-root user whenever possible to improve security and reduce the impact of potential security vulnerabilities.

* **Use Healthchecks**: Add healthcheck instructions to monitor the status of your application within the container and automatically restart containers that are unhealthy.

* **Use Docker BuildKit**: Enable Docker BuildKit (`DOCKER_BUILDKIT=1`) to take advantage of its improved caching and build capabilities.

* **Keep Secrets Secure**: Do not use ARG or ENV, use Docker secrets to securely pass sensitive information.

* **Keep Dockerfile Simple**: Keep your Dockerfile simple and easy to understand to facilitate maintenance and collaboration among team members.

* **Test Your Images**: Regularly test your Docker images by building and running them to ensure they function as expected and adhere to your requirements.

# Docker Compose Best Practices
* **Use Docker Compose for Complex Builds**: For complex builds involving multiple services, use Docker Compose to define and manage the build process more efficiently.