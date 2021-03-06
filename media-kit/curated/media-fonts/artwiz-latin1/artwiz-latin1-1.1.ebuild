# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A set of improved Artwiz fonts with bold and full ISO-8859-1 support"
HOMEPAGE="http://artwiz-latin1.sourceforge.net/"
SRC_URI="mirror://sourceforge/artwiz-latin1/${P}.tgz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="*"

S="${WORKDIR}/${PN}"

DOCS="README AUTHORS VERSION CHANGELOG"
FONT_S="${S}"
FONT_SUFFIX="pcf.gz"
