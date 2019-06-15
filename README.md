
[![CircleCI](https://circleci.com/gh/cyber-dojo-languages/image_dockerfile_augmenter.svg?style=svg)](https://circleci.com/gh/cyber-dojo-languages/image_dockerfile_augmenter)

Use cyberdojofoundation/image_dockerfile_augmenter to create images from the
cyber-dojo-languages Dockerfiles.
The Dockerfiles **cannot** be used to build a (working) docker image with a
raw `docker build` command. This is because the Dockerfile needs augmenting
to fulfil several [runner](https://github.com/cyber-dojo/runner)
requirements:
- it adds Linux user called sandbox
- it adds a Linux group called sandbox
- on Alpine it installs bash so every cyber-dojo.sh runs in the same shell
- on Alpine it installs coreutils so file stamp granularity is in microseconds
- on Alpine it installs file to allow (file --mime-encoding ${filename})
- on Alpine it updates tar to support the --touch option

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
