# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="babel-portuges beamer-tut-pt cursolatex feupphdteses hyphen-portuguese latex-via-exemplos latexcheat-ptbr lshort-portuguese numberpt ordinalpt xypic-tut-pt collection-langportuguese
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-portuges.doc beamer-tut-pt.doc cursolatex.doc feupphdteses.doc latex-via-exemplos.doc latexcheat-ptbr.doc lshort-portuguese.doc numberpt.doc ordinalpt.doc xypic-tut-pt.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-portuges.source numberpt.source ordinalpt.source "
inherit  texlive-module
DESCRIPTION="TeXLive Portuguese"

LICENSE=" GPL-1 GPL-2 GPL-2+ "
SLOT="0"
KEYWORDS="*"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2020
"
RDEPEND="${DEPEND} "
