# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="babel-czech babel-slovak cnbwp cs csbulletin cslatex csplain cstex hyphen-czech hyphen-slovak lshort-czech lshort-slovak texlive-cz collection-langczechslovak
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-czech.doc babel-slovak.doc cnbwp.doc csbulletin.doc cslatex.doc cstex.doc lshort-czech.doc lshort-slovak.doc texlive-cz.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-czech.source babel-slovak.source cslatex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Czech/Slovak"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 TeX-other-free "
SLOT="0"
KEYWORDS="*"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
>=dev-texlive/texlive-latex-2020
>=dev-texlive/texlive-basic-2019
>=dev-texlive/texlive-latex-2019
>=app-text/texlive-core-2014[xetex]
>=dev-texlive/texlive-luatex-2016
>=dev-texlive/texlive-langenglish-2019
>=dev-texlive/texlive-langeuropean-2019
>=dev-texlive/texlive-langfrench-2019
>=dev-texlive/texlive-langgerman-2019
>=dev-texlive/texlive-langpolish-2019
>=dev-texlive/texlive-langspanish-2019
>=dev-texlive/texlive-langitalian-2019
"
RDEPEND="${DEPEND} "
