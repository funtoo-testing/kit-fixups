# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="xml(+),threads(+)"

inherit distutils-r1

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"
SRC_URI="https://gitweb.gentoo.org/proj/gentoolkit.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="*"

DEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sys-apps/gawk
	sys-apps/gentoo-functions"

distutils_enable_tests setup.py

python_prepare_all() {
	python_setup
	echo VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all

	if use prefix-guest ; then
		# use correct repo name, bug #632223
		sed -i \
			-e "/load_profile_data/s/repo='gentoo'/repo='gentoo_prefix'/" \
			pym/gentoolkit/profile.py || die
	fi
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-0.4.0"; then
		SHOW_GENTOOKIT_DEV_DEPRECATED_MSG=1
	fi
}

pkg_postinst() {
	# Create cache directory for revdep-rebuild
	mkdir -p -m 0755 "${EROOT}"/var/cache
	mkdir -p -m 0700 "${EROOT}"/var/cache/revdep-rebuild

	if [[ ${SHOW_GENTOOKIT_DEV_DEPRECATED_MSG} ]]; then
		elog "Starting with version 0.4.0, ebump, ekeyword and imlate are now"
		elog "part of the gentoolkit package."
		elog "The gentoolkit-dev package is now deprecated in favor of a single"
		elog "gentoolkit package.   The remaining tools from gentoolkit-dev"
		elog "are now obsolete/unused with the git based tree."
	fi

	# Only show the elog information on a new install
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog "For further information on gentoolkit, please read the gentoolkit"
		elog "guide: https://wiki.gentoo.org/wiki/Gentoolkit"
		elog
		elog "Another alternative to equery is app-portage/portage-utils"
		elog
		elog "Additional tools that may be of interest:"
		elog
		elog "    app-admin/eclean-kernel"
		elog "    app-portage/diffmask"
		elog "    app-portage/flaggie"
		elog "    app-portage/portpeek"
		elog "    app-portage/smart-live-rebuild"
	fi
}
