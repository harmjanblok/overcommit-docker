FROM ruby:2.3.1

# fixes: https://github.com/bundler/bundler/issues/4576
RUN gem install bundler

WORKDIR /usr/src/app

ADD Gemfile Gemfile.lock /usr/src/app/
RUN bundle install --jobs 4

RUN chown -R nobody:nogroup /usr/src/app
USER nobody

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["overcommit", "-r"]
