# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python2_7)
DISTUTILS_SINGLE_IMPL="1"
inherit distutils-r1

if [[ -z ${PV%%*9999} ]]; then
	inherit cvs
	ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
	ECVS_MODULE="${PN}"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A high-level language for gridfitting TrueType fonts"
HOMEPAGE="http://xgridfit.sourceforge.net"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="
	media-gfx/fontforge[python]
"
RDEPEND="
	${DEPEND}
"
S="${WORKDIR}/${PN}/python"
HTML_DOCS=( "${S}/../docs/" )

src_prepare() {
	find "${WORKDIR}" -path '*/CVS*' -delete
	sed \
		-e 's:/usr/local:/usr:' \
		-i xgflib.py ../Makefile
	sed \
		-e "s:which python:which ${EPYTHON}:" \
		-e '/python setup.py/d' \
		-i ../Makefile
	distutils-r1_src_prepare
}

src_install() {
	emake -C "${S}"/.. DESTDIR="${D}" install
	distutils-r1_src_install
}
