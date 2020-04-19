#!/usr/bin/env bash

set -euo pipefail

mkdir -p /etc/portage/repos.conf /var/db/repos/${OVERLAY_NAME} /var/db/repos/gentoo /usr/portage /var/cache/distfiles || echo "Could not create dirs"
chmod a+rwX /etc/passwd /etc/group /etc /usr /var/db/repos /var /var/cache
echo "portage:x:250:250:portage:/var/tmp/portage:/bin/false" >> /etc/passwd
echo "portage::250:portage,travis" >> /etc/group

cp -r  * /var/db/repos/${OVERLAY_NAME}/ || echo "Could not copy repo"

# Get portage utils
wget -qO - "https://github.com/gentoo/portage/archive/portage-${PORTAGE_VER}.tar.gz" | tar xz -C /tmp

# Get portage tree
wget -qO - "https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz" | tar xz -C /var/db/repos/gentoo --strip-components=1

cp .travis/gentoo.conf /etc/portage/repos.conf/ || echo "Could not copy gentoo repo config"
cp .travis/${OVERLAY_NAME}.conf /etc/portage/repos.conf/ || echo "Could not copy overlay repo config"

mkdir -p /usr/portage/metadata/{dtd,xml-schema} || echo "Could not create metadata folders"
wget -O /usr/portage/metadata/dtd/metadata.dtd https://www.gentoo.org/dtd/metadata.dtd || echo "Could not download dtd"
wget -O /usr/portage/metadata/xml-schema/metadata.xsd https://www.gentoo.org/xml-schema/metadata.xsd || echo "Could not download xsd"
ln -s /var/db/repos/gentoo/profiles/default/linux/amd64 /etc/portage/make.profile
