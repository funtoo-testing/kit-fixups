# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool toolchain-funcs multilib-minimal

DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://jpegclub.org/ http://www.ijg.org/"
SRC_URI="http://www.ijg.org/files/${PN}src.v${PV}.tar.gz
	mirror://debian/pool/main/libj/lib${PN}8/lib${PN}8_8d-1.debian.tar.gz"

LICENSE="IJG"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

DEPEND=""
RDEPEND="!media-libs/libjpeg-turbo:0"

DOCS=( change.log example.c README {coderules,filelist,install,jconfig,libjpeg,structure,usage,wizard}.txt )

PATCHES=( "${FILESDIR}"/${PN}-7-maxmem_sysconf.patch )

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	# Fix building against this library on eg. Solaris and DragonFly BSD, see:
	# http://mail-index.netbsd.org/pkgsrc-bugs/2010/01/18/msg035644.html
	local ldverscript=
	[[ ${CHOST} == *-solaris* ]] && ldverscript="--disable-ld-version-script"

	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--enable-maxmem=64 \
		${ldverscript}
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi; then
		# Build exifautotran and jpegexiforient
		cd ../debian/extra
		emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die

	einstalldocs

	# Install exifautotran and jpegexiforient
	newdoc ../debian/changelog changelog.debian
	cd ../debian/extra
	emake \
		DESTDIR="${D}" prefix="${EPREFIX}"/usr \
		INSTALL="install -m755" INSTALLDIR="install -d -m755" \
		install
	# Remove +x bits from man pages.
	find "${ED}"/usr/share/man/ -type f -perm /1 -exec chmod a-x {} + || die
}
