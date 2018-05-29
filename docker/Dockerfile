FROM base/archlinux:latest

MAINTAINER Thomas Campistron <https://github.com/irevoire>

# update arch because why not
RUN pacman -Syu --noconfirm

# install everything you need
RUN pacman -S \
	gcc \
	git \
	inetutils \
	make \
	ruby \
	vim \
	zsh \
	--noconfirm

# get theme for zsh and vim
RUN git clone http://git.irevoire.ovh/irevoire/dotfiles.git ; \
	cd dotfiles ; mv vim/vim ~/.vim ; mv vim/vimrc ~/.vimrc ; mv zsh/zshrc ~/.zshrc

ENV TERM xterm-256color

# Now we get jsp
RUN pacman -S stack --noconfirm
RUN git clone http://www.fil.univ-lille1.fr/~hym/d/jsp.git ; cd jsp ; stack build
RUN  mv /jsp/.stack-work/install/x86_64-linux-tinfo6/lts-7.8/8.0.1/bin/jsp /bin/jsp
RUN pacman -Rns stack --noconfirm
RUN rm -rf jsp

# get the project
RUN git clone https://github.com/sophie-kaleba/turbo-air-dryer.git

ENTRYPOINT zsh

WORKDIR /turbo-air-dryer
