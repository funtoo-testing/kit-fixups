# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="Print out X-Video extension adaptor information"

KEYWORDS="*"
IUSE=""

RDEPEND="x11-libs/libXv
	x11-libs/libX11"
DEPEND="${RDEPEND}"
