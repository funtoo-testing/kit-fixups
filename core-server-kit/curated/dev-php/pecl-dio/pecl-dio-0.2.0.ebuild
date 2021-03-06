# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="dio"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-4 php7-2 php7-3"

MY_PV=${PV/_rc/RC}
PHP_EXT_S="${WORKDIR}/${PN/pecl-/}-${MY_PV}"

inherit php-ext-pecl-r3

KEYWORDS="*"

DESCRIPTION="Direct I/O functions for PHP"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

S="${PHP_EXT_S}"
