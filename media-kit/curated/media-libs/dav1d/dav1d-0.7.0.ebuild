# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson ninja-utils multilib-minimal

DESCRIPTION="dav1d is an AV1 Decoder :)"
HOMEPAGE="https://code.videolan.org/videolan/dav1d"
SRC_URI="https://code.videolan.org/videolan/dav1d/-/archive/${PV}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0/4"
KEYWORDS="*"
IUSE="+8bit +10bit +asm"

ASM_DEPEND=">=dev-lang/nasm-2.14.02"
BDEPEND="asm? (
		abi_x86_32? ( ${ASM_DEPEND} )
		abi_x86_64? ( ${ASM_DEPEND} )
	)"

DOCS=( README.md doc/PATENTS THANKS.md )

multilib_src_configure() {
	local -a bits=()
	use 8bit  && bits+=( 8 )
	use 10bit && bits+=( 16 )

	local enable_asm
	if [[ ${MULTILIB_ABI_FLAG} == abi_x86_x32 ]]; then
		enable_asm=false
	else
		enable_asm=$(usex asm true false)
	fi

	local emesonargs=(
		-D bitdepths=$(IFS=,; echo "${bits[*]}")
		-D enable_asm=${enable_asm}
	)
	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
