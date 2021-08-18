FROM archlinux:latest

RUN pacman -Syu --noconfirm --needed base-devel git sudo
RUN mkdir /repos
RUN chmod 777 /repos

RUN useradd -m -s /bin/bash -d /build build
RUN echo "build ALL=NOPASSWD: ALL" >> /etc/sudoers

USER build

RUN git clone https://aur.archlinux.org/neovim-nightly-bin.git /repos/neovim-nightly-bin
WORKDIR /repos/neovim-nightly-bin
RUN makepkg -si --noconfirm

WORKDIR /
USER root
RUN rm -rf /repos

# Providers
RUN pacman -Syu --noconfirm python3 python-pip python2 python2-pip nodejs yarn
RUN pip install neovim
RUN pip2 install pynvim
RUN yarn global add neovim

# Utils
RUN pacman -Syu --noconfirm fzf ripgrep curl

# LSP
RUN yarn global add \
  typescript-language-server \
  typescript vim-language-server \
  vim-language-server \
  yaml-language-server \
  diagnostic-languageserver \
  eslint \
  eslint_d \
  prettier

# Config & Plugins
# COPY config /root/.config/nvim
# RUN nvim +'PlugInstall --sync' +qall

VOLUME ["/root/.config/nvim"]
VOLUME ["/src"]
WORKDIR /src

# USER 1000
CMD nvim .
