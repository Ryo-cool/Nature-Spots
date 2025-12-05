FROM node:20-alpine

ENV HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

ENV HOST 0.0.0.0

WORKDIR ${HOME}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache git openssh && \
    rm -rf /var/cache/apk/*

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# 非rootで実行してセキュリティを高める
RUN chown -R node:node ${HOME}
USER node

EXPOSE 3000

CMD ["yarn", "dev"]
