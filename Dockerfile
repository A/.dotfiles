FROM archlinux

RUN pacman -Syu --noconfirm sudo which ansible

RUN groupadd sudo
RUN useradd -m docker
RUN usermod docker -aG sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
ENV USER=docker
WORKDIR /home/docker/.dotfiles

ENV ANSIBLE_EXECUTABLE=/usr/bin/sh
CMD ansible-playbook dotfiles.yml
