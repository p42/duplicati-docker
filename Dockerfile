FROM project42/s6-archlinux:latest
MAINTAINER Jordan Clark mail@jordanclark.us

ENV DUPLICATI_VERSION 2.0.4.15-1
ENV DUPLICATI_MD5HASH b099a144d91af95998d15fc2f1783459
ENV HARDWARE_ARCH x86_64

COPY container-files /

RUN pacman --noconfirm -Syu && \
pacman --noconfirm -S binutils fakeroot sudo && \
pacman --noconfirm -S gtk-sharp-2 mono && \
mkdir /home/build && \
chgrp nobody /home/build && \
chmod g+ws /home/build && \
setfacl -m u::rwx,g::rwx /home/build && \
setfacl -d --set u::rwx,g::rwx,o::- /home/build && \
cd /tmp && \
wget https://aur.archlinux.org/cgit/aur.git/snapshot/duplicati-latest.tar.gz && \
echo "$DUPLICATI_MD5HASH *duplicati-latest.tar.gz" | md5sum -c - && \
sudo -u nobody tar xzf duplicati-latest.tar.gz -C /home/build/ && \
rm duplicati-latest.tar.gz && \
cd /home/build/duplicati-latest && \
sudo -u nobody makepkg -rc && \
pacman --noconfirm -U duplicati-latest-$DUPLICATI_VERSION-$HARDWARE_ARCH.pkg.tar.xz && \
pacman --noconfirm -R binutils fakeroot sudo && \
rm -rf /usr/share/man/* /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /etc/pacman.d/mirrorlist.pacnew && \
rm -rf /home/build && \
mkdir /etc/duplicati && \
mkdir /system

VOLUME /etc/duplicati
EXPOSE 8200
ENTRYPOINT ["/init"]
