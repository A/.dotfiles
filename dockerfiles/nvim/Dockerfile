FROM archlinux:latest

# Install basic deps
RUN pacman -Syu --noconfirm --needed base-devel git sudo npm jq

# Create a user 1000
RUN useradd -m -s /bin/bash -d /user user
RUN echo "user ALL=NOPASSWD: ALL" >> /etc/sudoers

USER user
ENV HOME=/user

# Setup AURs
ENV AURS_DIR="${HOME}/aurs"
RUN mkdir -p $AURS_DIR

# Install neovim nightly from aurs
RUN git clone https://aur.archlinux.org/neovim-nightly-bin.git ${AURS_DIR}/neovim-nightly-bin
WORKDIR "${AURS_DIR}/neovim-nightly-bin"
RUN makepkg -si --noconfirm

WORKDIR "${HOME}"
RUN rm -rf ${AURS_DIR}

ENV SHARED_DIR="${HOME}/.local/share"

ENV PATH="${SHARED_DIR}/npm/bin/:${PATH}"
RUN npm config --global set prefix ${SHARED_DIR}/npm

# Install neovim providers
RUN sudo pacman -Syu --noconfirm python3 python-pip python2 python2-pip nodejs npm
RUN pip install neovim
RUN pip2 install pynvim
RUN npm i -g neovim

# Install shell utils
RUN sudo pacman -Syu --noconfirm fzf ripgrep curl bat fd


# Config:
VOLUME ["${HOME}/.config/nvim"]

# Local cache:
VOLUME ["${HOME}/.local/share"]

# Source Code:
VOLUME ["/src"]

WORKDIR /src

# USER 1000
CMD nvim .
