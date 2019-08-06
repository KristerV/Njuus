FROM ubuntu:16.04

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV HOME=/root
ENV REFRESHED_AT=2018-08-16
ENV TERM=xterm
ENV PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

WORKDIR /root

RUN apt update -y && \
    apt install -y git locales wget \
    automake autoconf libreadline-dev \
    libncurses-dev libssl-dev libyaml-dev \
    libxslt-dev libffi-dev libtool unixodbc-dev \
    unzip curl build-essential m4 libncurses5-dev \
    libssh-dev

RUN locale-gen en_US.UTF-8

# Install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.3 && \
    /bin/bash -c "\
        echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc && \
        echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc && \
        source ~/.bashrc \
    "

# Install erlang
RUN asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
    asdf install erlang 22.0.7 && \
    asdf global erlang 22.0.7 && \
    rm -rf  /tmp/*

# Install elixir
RUN asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && \
    asdf install elixir 1.8.2 && \
    asdf global elixir 1.8.2 && \
    rm -rf  /tmp/*

# Install node js
RUN asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
    $HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring && \
    asdf install nodejs 8.16.0 && \
    asdf global nodejs 8.16.0 && \
    rm -rf  /tmp/*

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force
