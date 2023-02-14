# How to Develop a Hugo Website in a Docker Container

The purpose of this repo is to develop static websites using the Hugo package in a Docker
container which can then be bundled and distributed in a Caddy image.

Here are the steps required to use the scripts included in this repo.

## Create New Site Repo and Hugo Image

This repo has been designated as a template. To create a new Hugo site based on this, simply use the "Use this template" button to create a new repo with these files. Then clone the newly created repo and continue with the instructions below.

Run the `build.sh` script to build a new hugo Docker container based on the official `klakegg/hugo:ext-debian` image. The script uses the `Dockerfile.build` file. You will use this container to run the `hugo` command to build the static version of your website in the future.

**Why work inside a Docker container?** Using Docker containers allow software or website developers to isolate the various depencies required for development projects. A developer may find, for example, that one version of Hugo is necesseary for one website, but another project requires a different version. By developing inside a container, it’s possible to manage those dependencies in a repeatable and predictable way. If two developers are collaborating on a project, it also makes it easier to ensure that both developers are working with the same software even if they’re using different platforms.

## Install Hugo

Once the image is created, open the folder in VSCode and then reopen it in a docker container by clicking on the green icon in the lower-left corner of the VSCode window and choosing the “Reopen in Container” option. Choose the `Dockerfile.build` Dockerfile.

From the VSCode terminal inside the newly created hugo container, run the `install-hugo.sh` script which will install the necessary tools and create a new Hugo site in the `www` directory. I'm putting the site in the `www` directory because I want to keep it separate from the Dockerfiles and scripts.

Once the site is created, run the local server with the `hugo server` command from inside the `www` directory. The server will automatically rebuild your site as you edit and add pages. You can view a live version of your website at http://localhost:1313/. Use `hugo server -D` if you want the demo server to show draft content.

Now you can go ahead and edit the website, add blog posts, other pages, etc. The site can be tracked in git as any other project.

## Publishing the Site to a Caddy Image

Once the site is ready to publish, run the `publish.sh` script from outside the container to copy the contents of the `public` directory into a new Caddy image based on the published `caddy:2-alpine` docker image. There are two options you can pass to the script.

`./publish.sh test` builds the site into a Docker container and runs the container locally so you can see if everything looks OK.

`./publish.sh production` builds the site Docker container as a multi-platform image (arm64 and amd64) and pushes it to hub.docker.com. You must add your hub.docker.com username at the top of the `./publish.sh` script right after the initial comment block. **The script takes the name of the parent directory as the image name.**

Once the image is pushed to hub.docker.com, you can deploy it to your web server and run it to serve your website. Note: the production image assumes that you'll be running it in conjunction with a reverse proxy that will connect to your website image accepting connections on port 8000 and negotiate the standard and SSL connections on ports 80 and 443 for external clients.

## Credit

Thanks to Bill Raymond for his helpful YouTube video and associated [git repo](https://github.com/BillRaymond/my-jekyll-docker-website). His approach inspired mine.
