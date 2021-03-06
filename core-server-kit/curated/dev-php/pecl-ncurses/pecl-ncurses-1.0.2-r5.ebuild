# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-4 php7-2 php7-3"

inherit php-ext-pecl-r3

KEYWORDS="*"

SRC_URI+=" https://dev.gentoo.org/~grknight/distfiles/${P}-php7.patch.xz"

DESCRIPTION="Terminal screen handling and optimization package"

LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PHP_EXT_ECONF_ARGS=( --enable-ncursesw )
PATCHES=( "${WORKDIR}/${P}-php7.patch" "${FILESDIR}/${P}-php7.3.patch" )
