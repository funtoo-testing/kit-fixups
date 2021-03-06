# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sound Open Firmware (SOF) binary files"

HOMEPAGE="https://www.sofproject.org https://github.com/thesofproject/sof https://github.com/thesofproject/sof-bin"
SRC_URI="https://github.com/thesofproject/sof-bin/archive/stable-v${PV}.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${WORKDIR}/sof-bin-stable-v${PV}

pkg_setup() {
	export SOF_VERSION=v${PV}
}

src_compile() {
	sed -i -e '1i #!/bin/bash\nset -e' \
		-e '/^ROOT=/d' \
		-e "s/^VERSION=.*/VERSION=v${PV}/" go.sh || die
}

src_install() {
	mkdir -p ${D}/lib/firmware || die
	ROOT=${D} ${S}/go.sh || die
}
