# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Usually apr-util has the same PV as apr, but in case of security fixes, this may change.
# APR_PV="${PV}"
APR_PV="1.6.2"

inherit autotools db-use libtool multilib toolchain-funcs

DESCRIPTION="Apache Portable Runtime Utility Library"
HOMEPAGE="https://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="*"
IUSE="berkdb doc gdbm ldap libressl mysql nss odbc openssl postgres sqlite static-libs"
#RESTRICT="test"

RDEPEND="
	dev-libs/expat
	>=dev-libs/apr-${APR_PV}:1=
	berkdb? ( >=sys-libs/db-6:= )
	gdbm? ( sys-libs/gdbm:= )
	ldap? ( =net-nds/openldap-2* )
	mysql? ( || (
		dev-db/mariadb-connector-c
		dev-db/mysql-connector-c
	) )
	nss? ( dev-libs/nss )
	odbc? ( dev-db/unixODBC )
	openssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="
	${RDEPEND}
	>=sys-devel/libtool-2.4.2
	doc? ( app-doc/doxygen )
"

DOCS=(CHANGES NOTICE README)

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.3-sysroot.patch #385775
	"${FILESDIR}"/${PN}-1.6.1-fix-gdbm-error-handling.patch
)

src_prepare() {
	default

	# Fix usage of libmysqlclient (bug #620230)
	grep -lrF "libmysqlclient_r" "${S}" \
		| xargs sed 's@libmysqlclient_r@libmysqlclient@g' -i \
		|| die

	mv configure.{in,ac} || die
	eautoreconf
	elibtoolize
}

src_configure() {
	local myconf=(
		--datadir="${EPREFIX}"/usr/share/apr-util-1
		--with-apr="${SYSROOT}${EPREFIX}"/usr
		--with-expat="${EPREFIX}"/usr
		--without-sqlite2
		$(use_with gdbm)
		$(use_with ldap)
		$(use_with mysql)
		$(use_with nss)
		$(use_with odbc)
		$(use_with openssl)
		$(use_with postgres pgsql)
		$(use_with sqlite sqlite3)
		$(use_with berkdb berkeley-db)
)

	tc-is-static-only && myconf+=( --disable-util-dso )

	if use nss || use openssl ; then
		myconf+=( --with-crypto ) # 518708
	fi

	econf "${myconf[@]}"
	# Use the current env build settings rather than whatever apr was built with.
	sed -i -r \
		-e "/^(apr_builddir|apr_builders|top_builddir)=/s:=:=${SYSROOT}:" \
		-e "/^CC=/s:=.*:=$(tc-getCC):" \
		-e '/^(C|CPP|CXX|LD)FLAGS=/d' \
		-e '/^LTFLAGS/s:--silent::' \
		build/rules.mk || die
}

src_compile() {
	emake
	use doc && emake dox
}

src_test() {
	# Building tests in parallel is broken
	emake -j1 check
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die
	if [[ -d "${ED%/}/usr/$(get_libdir)/apr-util-${SLOT}" ]] ; then
		find "${ED%/}/usr/$(get_libdir)/apr-util-${SLOT}" -name "*.a" -delete || die
	fi
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -not -name "*$(get_libname)" -delete || die
	fi

	if use doc ; then
		docinto html
		dodoc -r docs/dox/html/*
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	rm "${ED%/}/usr/$(get_libdir)/aprutil.exp" || die
}
