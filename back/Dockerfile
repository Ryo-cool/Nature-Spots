FROM ruby:3.2.3-alpine

ENV RUNTIME_PACKAGES="linux-headers libxml2-dev libxslt-dev zlib-dev build-base pkgconfig git nodejs tzdata mysql-dev mysql-client sqlite-libs sqlite-dev yarn bash" \
    DEV_PACKAGES="curl-dev" \
    HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_FORCE_RUBY_PLATFORM=1 \
    RAILS_ENV=development \
    NODE_ENV=development

ENV BUNDLE_PATH=$HOME/vendor/bundle

WORKDIR ${HOME}

COPY Gemfile Gemfile.lock ${HOME}/

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache ${RUNTIME_PACKAGES} && \
    apk add --update --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    BUNDLER_VERSION=$(grep -A1 "BUNDLED WITH" Gemfile.lock | tail -n1 | tr -d ' ') && \
    gem install bundler:${BUNDLER_VERSION} && \
    bundle _${BUNDLER_VERSION}_ config set --local path ${BUNDLE_PATH} && \
    bundle _${BUNDLER_VERSION}_ install --jobs ${BUNDLE_JOBS} --retry ${BUNDLE_RETRY} && \
    addgroup -g 1000 app && \
    adduser -D -h ${HOME} -G app app && \
    apk del build-dependencies && \
    rm -rf /usr/local/bundle/cache/* \
    /usr/local/share/.cache/* \
    /var/cache/* \
    /tmp/* \
    /usr/lib/mysqld* \
    /usr/bin/mysql*

COPY . ${HOME}
RUN chown -R app:app ${HOME}

USER app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000", "-e", "development"]
