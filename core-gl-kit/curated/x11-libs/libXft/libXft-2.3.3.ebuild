# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MULTILIB=yes
inherit xorg-2 flag-o-matic

DESCRIPTION="X.Org Xft library"

KEYWORDS="*"
IUSE=""

RDEPEND=">=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1[${MULTILIB_USEDEP}]
	virtual/ttf-fonts
	x11-base/xorg-proto
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
