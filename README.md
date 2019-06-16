
[![CircleCI](https://circleci.com/gh/cyber-dojo-languages/image_dockerfile_augmenter.svg?style=svg)](https://circleci.com/gh/cyber-dojo-languages/image_dockerfile_augmenter)

- given a Dockerfile, creates a new Dockerfile, augmented to fulfil [runner's](https://github.com/cyber-dojo/runner) requirements:
  - it adds Linux user called sandbox
  - it adds a Linux group called sandbox
  - on Alpine it installs bash so every cyber-dojo.sh runs in the same shell
  - on Alpine it installs coreutils so file stamp granularity is in microseconds
  - on Alpine it installs file to allow (file --mime-encoding ${filename})
  - on Alpine it updates tar to support the --touch option
- used in the main [build_test_push_notify.sh](https://github.com/cyber-dojo-languages/image_builder/blob/master/build_test_push_notify.sh) script of all [cyber-dojo-languages](https://github.com/cyber-dojo-languages) repos .circleci/config.yml files

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
