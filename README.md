# How to Develop a Hugo Website in a Docker Container

The purpose of this repo is to develop static websites using the Hugo package in a docker
container which can then be bundled and distributed in a Caddy image.

Here are the steps required to use the scripts included in this repo.

## Create New Site Repo and Hugo Image

This repo has been designated as a template. To create a new Hugo site based on this, simply use the "Use this template" button to create a new repo with these files. Then clone the newly created repo and continue with the instructions below.

Then run the `build.sh` script to build a new `hugo-site` image based on the official `klakegg/hugo:ext-debian` image. The script uses the `Dockerfile-build` file.

## Install Hugo

Once the image is created, open the folder in VSCode and then reopen it in a docker container based on the `Dockerfile-build` Dockerfile.

From the VSCode terminal inside the newly created `jekyll-site` image, run the `install-jekyll.sh` script which will install the necessary tools and create a new Hugo site in the `www` directory.

I'm putting the site in the `www` directory because I want to keep it separate from the Dockerfiles and scripts.

Once the site is created, run the local server with the `hugo server` command.

Now you can go ahead and edit the website, add blog posts, other pages, etc. The site can be tracked in git as any other project.

## Publishing the Site to a Caddy Image

Once the site is ready to publish, run the `publish.sh` script from outside the container to copy the contents of the `public` directory into a new Caddy image based on the published `caddy:2-alpine` docker image. **The script takes the name of the parent directory as the image name.**

Run the newly created Caddy image locally with the following command replacing `IMAGE_NAME` with the name of the Caddy image:

`docker run -p 80:80 IMAGE_NAME`

With the image created, you can publish it to hub.docker.com and run it on your remote host.

## Credit

Thanks to Bill Raymond for his helpful YouTube video and associated [git repo](https://github.com/BillRaymond/my-jekyll-docker-website). His approach inspired mine.
