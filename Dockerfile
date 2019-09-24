FROM alpine:latest AS builder
ENV JSONNET_VERSION="v0.14.0"

RUN apk add --update ca-certificates git build-base

WORKDIR /opt
RUN git clone https://github.com/google/jsonnet
RUN cd jsonnet && \
    git checkout ${JSONNET_VERSION} && \
    make

FROM ruby:2.6-alpine

### Jsonnet
COPY --from=builder /opt/jsonnet/jsonnetfmt /usr/local/bin

RUN apk add --update ca-certificates --no-cache libstdc++ python3 make g++ git bash
RUN pip3 install --upgrade yamllint

ENV HOME /overcommit
WORKDIR ${HOME}

ADD Gemfile Gemfile.lock ${HOME}/
RUN bundle install --jobs 4

# Set a fake git identity
RUN git config --global user.name "John Doe"
RUN git config --global user.email johndoe@example.com

RUN chown -R nobody:nogroup ${HOME}
USER nobody
SHELL ["/bin/bash"]
WORKDIR /usr/src/app

CMD ["overcommit", "-r"]
