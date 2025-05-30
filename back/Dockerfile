# イメージの指定
FROM ruby:3.3.0-alpine

# 必要パッケージのダウンロード
ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata mysql-dev mysql-client yarn bash" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# 作業ディレクトリに移動
WORKDIR ${HOME}

# ホスト（自分のパソコンにあるファイル）から必要ファイルをDocker上にコピー
COPY Gemfile ${HOME}/Gemfile

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache ${RUNTIME_PACKAGES} && \
    apk add --update --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    gem install bundler && \
    bundle install -j4 && \
    apk del build-dependencies && \
    rm -rf /usr/local/bundle/cache/* \
    /usr/local/share/.cache/* \
    /var/cache/* \
    /tmp/* \
    /usr/lib/mysqld* \
    /usr/bin/mysql*

# ホスト（自分のパソコンにあるファイル）から必要ファイルをDocker上にコピー
COPY . ${HOME}

# ポート3000番をあける
EXPOSE 3000

# コマンドを実行
CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "development"]
