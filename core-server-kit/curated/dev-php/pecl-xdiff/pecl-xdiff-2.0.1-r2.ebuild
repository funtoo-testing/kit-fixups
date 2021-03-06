# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="xdiff"
PHP_EXT_PECL_PKG="xdiff"
DOCS=( README.API )

USE_PHP="php7-4 php7-2 php7-3"

inherit php-ext-pecl-r3

KEYWORDS="*"

DESCRIPTION="PHP extension for generating diff files"
LICENSE="PHP-3.01"
SLOT="7"

DEPEND="
	php_targets_php7-4? ( dev-libs/libxdiff )
	php_targets_php7-2? ( dev-libs/libxdiff )
	php_targets_php7-3? ( dev-libs/libxdiff )
"
RDEPEND="${DEPEND}"

src_prepare() {
	if use php_targets_php7-4 || use php_targets_php7-3 || use php_targets_php7-2 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-4 || use php_targets_php7-3 || use php_targets_php7-2 ; then
		local PHP_EXT_ECONF_ARGS=()
		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php7-4 || use php_targets_php7-3 || use php_targets_php7-2 ; then
		php-ext-pecl-r3_src_install
	fi
}
