# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://anongit.freedesktop.org/git/mesa/drm.git"

inherit ${GIT_ECLASS} meson multilib-minimal

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="https://dri.freedesktop.org/"
SRC_URI="https://dri.freedesktop.org/libdrm/${P}.tar.xz"
KEYWORDS="*"

VIDEO_CARDS="amdgpu exynos freedreno intel nouveau omap radeon tegra vc4 vivante vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} libkms valgrind"
RESTRICT="test" # see bug #236845
LICENSE="MIT"
SLOT="0"

RDEPEND="elibc_FreeBSD? ( >=dev-libs/libpthread-stubs-0.4:=[${MULTILIB_USEDEP}] )
	video_cards_intel? ( >=x11-libs/libpciaccess-0.13.1-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

multilib_src_configure() {
	local emesonargs=(
		# Udev is only used by tests now.
		-Dudev=false
		-Dcairo-tests=false
		-Damdgpu=$(usex video_cards_amdgpu true false)
		-Dexynos=$(usex video_cards_exynos true false)
		-Dfreedreno=$(usex video_cards_freedreno true false)
		-Dintel=$(usex video_cards_intel true false)
		-Dnouveau=$(usex video_cards_nouveau true false)
		-Domap=$(usex video_cards_omap true false)
		-Dradeon=$(usex video_cards_radeon true false)
		-Dtegra=$(usex video_cards_tegra true false)
		-Dvc4=$(usex video_cards_vc4 true false)
		-Detnaviv=$(usex video_cards_vivante true false)
		-Dvmwgfx=$(usex video_cards_vmware true false)
		-Dlibkms=$(usex libkms true false)
		# valgrind installs its .pc file to the pkgconfig for the primary arch
		-Dvalgrind=$(usex valgrind auto false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
