
[![Github Action (master)](https://github.com/cyber-dojo-tools/image_dockerfile_augmeter/actions/workflows/main.yml/badge.svg)](https://github.com/cyber-dojo-tools/image_dockerfile_augmeter/actions)

- reads a Dockerfile on stdin, creates a new Dockerfile, augmented to fulfil [runner's](https://github.com/cyber-dojo/runner) requirements:
  - adds a Linux user called sandbox
  - adds a Linux group called sandbox
  - on Alpine it installs bash so every cyber-dojo.sh runs in the same shell
  - on Alpine it installs coreutils so file stamp granularity is in microseconds
  - on Alpine it installs file to allow (file --mime-encoding ${filename})
  - on Alpine it updates tar to support the --touch option
- used in the main [image_build_test_push_notify.sh](https://github.com/cyber-dojo-tools/image_builder/blob/master/image_build_test_push_notify.sh) script of all [cyber-dojo-languages](https://github.com/cyber-dojo-languages) repos .circleci/config.yml files

```bash
$ git clone https://github.com/cyber-dojo-languages/python-pytest.git
$ cd python-pytest
$ cat /docker/Dockerfile.base
FROM cyberdojofoundation/python
LABEL maintainer=jon@jaggersoft.com
RUN pip3 install --upgrade pytest
COPY red_amber_green.rb /usr/local/bin

$ cat docker/Dockerfile.base \
    | \
      docker run \
        --interactive \
        --rm \
        --volume /var/run/docker.sock:/var/run/docker.sock \
          cyberdojofoundation/image_dockerfile_augmenter

FROM cyberdojofoundation/python
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# START of extra commands to fulfil runner's requirements (os=Debian)
RUN (getent group sandbox) || (addgroup --gid 51966 sandbox)
RUN (grep -q sandbox:x:41966 /etc/passwd) || (adduser --disabled-password --gecos "" --home /home/sandbox --ingroup sandbox --shell /bin/bash --uid 41966 sandbox)
RUN apt-get update && apt-get install --yes coreutils bash tar file
# END of extra commands to fulfil runner's requirements
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LABEL maintainer=jon@jaggersoft.com
RUN pip3 install --upgrade pytest
COPY red_amber_green.rb /usr/local/bin
```

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
