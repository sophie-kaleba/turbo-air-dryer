FROM base/archlinux:latest

MAINTAINER Thomas Campistron <https://github.com/irevoire>

# update arch because why not
RUN pacman -Syu --noconfirm ; \
	pacman -Scc --noconfirm ; rm -rf /var/cache/pacman/pkg/*
# pacman seems to not clear the cache when we do Scc so I'm gonna do it manually

# install everything you need
RUN pacman -S \
	gcc \
	git \
	make \
	ruby \
	vim \
	zsh \
	--noconfirm ; \
	pacman -Scc --noconfirm ; rm -rf /var/cache/pacman/pkg/*

# get theme for zsh and vim
RUN git clone http://git.irevoire.ovh/irevoire/dotfiles.git ; \
	cd dotfiles ; mv vim/vim ~/.vim ; mv vim/vimrc ~/.vimrc ; \
	mv zsh/zshrc ~/.zshrc ; \
	rm -rf /dotfiles

# Now we get jsp
# in order to compile jsp we need stack
RUN pacman -S stack --noconfirm ; \
	git clone http://www.fil.univ-lille1.fr/~hym/d/jsp.git ; cd jsp ; stack build ; \
	mv /jsp/.stack-work/install/x86_64-linux-tinfo6/lts-7.8/8.0.1/bin/jsp /bin/jsp ; \
	rm -rf /jsp ; \
	pacman -Rns stack --noconfirm ; \
	pacman -Scc stack --noconfirm ; \
	rm -rf ~/.stack /var/cache/pacman/pkg/*
# we need to remove stack because it takes about 4Go

# get the project
RUN git clone https://github.com/sophie-kaleba/turbo-air-dryer.git
# compile the ruby extension
RUN cd /turbo-air-dryer/ruby/c_wrapper ; ruby extconf.rb ; make


ENV TERM xterm-256color

ENTRYPOINT zsh

WORKDIR /turbo-air-dryer
