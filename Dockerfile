FROM ruby:2.3.1

# fixes: https://github.com/bundler/bundler/issues/4576
RUN gem install bundler

ENV HOME /overcommit
WORKDIR ${HOME}

ADD Gemfile Gemfile.lock ${HOME}/
RUN bundle install --jobs 4

# Set a fake git identity
RUN git config --global user.name "John Doe"
RUN git config --global user.email johndoe@example.com

RUN chown -R nobody:nogroup ${HOME}
USER nobody

WORKDIR /usr/src/app

CMD ["overcommit", "-r"]
