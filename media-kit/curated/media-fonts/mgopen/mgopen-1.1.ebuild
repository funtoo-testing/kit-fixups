# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Magenta MgOpen typeface collection for Modern Greek"
HOMEPAGE="http://www.ellak.gr/pub/fonts/mgopen/index.en.html"
# mirrored from debian tarball
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MagentaMgOpen"
SLOT="0"
KEYWORDS="*"

FONT_S=${S}
FONT_SUFFIX="ttf"
