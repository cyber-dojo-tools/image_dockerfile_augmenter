FROM alpine:latest
LABEL maintainer=jon@jaggersoft.com

# alpine publishes an index holding real arm64 layers, so an arm64 runner gets
# arm64 binaries here. A base published for one architecture only would still
# build under --platform linux/arm64, and the result would be an image labelled
# arm64 whose binaries an arm64 kernel cannot exec.
#
# ruby runs augment.rb, which needs no gems. The docker CLI is needed because
# augment.rb runs the FROM image to read its /etc/issue.
RUN apk add --no-cache \
    docker-cli \
    ruby

COPY . /app

ENTRYPOINT [ "ruby", "/app/src/augment.rb" ]
