FROM ubuntu:20.04
ARG userid
ARG groupid
ARG username

RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
RUN sed -i "s@http://.*security.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list

RUN DEBIAN_FRONTEND="noninteractive" apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get upgrade -y

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y git-core gnupg flex bison build-essential
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y	zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y	x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y	fontconfig libncurses5 procps rsync flex m4 openjdk-8-jdk lib32stdc++6 libelf-dev mtools libssl-dev 
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y python-enum34 python3-mako syslinux-utils sudo bc genisoimage dosfstools kmod adb git-lfs

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1

# Disable some gpg options which can cause problems in IPv4 only environments
RUN mkdir ~/.gnupg && chmod 600 ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# Download and verify repo
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
 && chmod a+x /usr/local/bin/repo

RUN groupadd -g $groupid $username \
 && useradd -m -s /bin/bash -u $userid -g $groupid $username \
 && echo "$username:$username" | chpasswd && adduser $username sudo
RUN usermod -a -G plugdev $username
COPY gitconfig /home/$username/.gitconfig
RUN chown $userid:$groupid /home/$username/.gitconfig

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $username /commandhistory \
    && echo "$SNIPPET" >> "/home/$username/.bashrc"

RUN mkdir /aosp && chown $userid:$groupid /aosp && chmod ug+s /aosp

WORKDIR /
USER $username
