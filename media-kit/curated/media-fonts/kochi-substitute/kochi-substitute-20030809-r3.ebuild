# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Kochi Japanese TrueType fonts with Wadalab Fonts"
HOMEPAGE="http://efont.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/efont/5411/${P}.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="*"
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${PN}-${PV:0:8}"

DOCS="README.ja Changelog"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	dodoc -r docs/{README,kappa20,k14goth,ayu20gothic,wadalab,shinonome*,naga10}
}
