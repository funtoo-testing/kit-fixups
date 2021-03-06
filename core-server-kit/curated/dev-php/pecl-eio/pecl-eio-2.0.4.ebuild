# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PHP_EXT_NAME="eio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( README.md )

USE_PHP="php7-2 php7-3 php7-4"
inherit php-ext-pecl-r3

KEYWORDS="*"
LICENSE="PHP-3.01"

DESCRIPTION="PHP wrapper for libeio library"
LICENSE="PHP-3"
SLOT="0"
IUSE="debug"

src_configure() {
	local PHP_EXT_ECONF_ARGS="--with-eio $(use_enable debug eio-debug)"
	php-ext-source-r3_src_configure
}
