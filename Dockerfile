FROM ruby:2.3.1

# fixes: https://github.com/bundler/bundler/issues/4576
RUN gem install bundler

ENV HOME /overcommit
WORKDIR ${HOME}

ADD Gemfile Gemfile.lock ${HOME}/
RUN bundle install --jobs 4

RUN chown -R nobody:nogroup ${HOME}
USER nobody

ADD docker-entrypoint.sh /

WORKDIR /usr/src/app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["overcommit", "-r"]
