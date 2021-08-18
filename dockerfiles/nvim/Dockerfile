FROM alpine:latest

# TODO: Split build and actual containers
# TODO: Reduce size from 2.4gb

RUN apk add --update \
  neovim \
  neovim-doc \
  python3 \
  python2 \
  py-pip \
  nodejs \
  yarn \
  npm \
  curl \
  fzf \
  bash \
  git \
  gcc \
  python2-dev \
  python3-dev \
  musl-dev \
  g++\
  ripgrep

RUN pip install neovim
RUN pip3 install neovim

RUN npm i -g neovim bash-language-server typescript-language-server vim-language-server yaml-language-server

COPY config /root/.config/nvim

RUN nvim +'PlugInstall --sync' +qall

VOLUME ["/src"]

WORKDIR /src

CMD nvim .


