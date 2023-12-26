FROM bitnami/jsonnet:0.18.0 as jsonnet
FROM golangci/golangci-lint:v1.50.0 as golangci-lint
FROM ruby:3.3-alpine

COPY --from=jsonnet /opt/bitnami/jsonnet/bin/jsonnetfmt /usr/local/bin
COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin

RUN apk add --no-cache --update \
      bash \
      ca-certificates \
      g++ \
      git \
      go \
      libstdc++ \
      make \
      py3-pip \
      python3 \
      shellcheck
RUN pip3 install --upgrade yamllint

ENV HOME /overcommit
WORKDIR ${HOME}

ADD Gemfile Gemfile.lock ${HOME}/
RUN bundle install --jobs 4

# Set a fake git identity
RUN git config --global user.name "John Doe"
RUN git config --global user.email johndoe@example.com
# Define workdir as safe.directory
RUN git config --global --add safe.directory /usr/src/app

RUN chown -R nobody:nogroup ${HOME}
USER nobody
SHELL ["/bin/bash"]
WORKDIR /usr/src/app

CMD ["overcommit", "-r"]
