# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

if [[ -z ${PV%%*9999} ]]; then
	inherit cvs
	ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
	ECVS_MODULE="${PN}"
else
	SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A high-level language for gridfitting TrueType fonts"
HOMEPAGE="http://xgridfit.sourceforge.net"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		dev-libs/libxml2[python,${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
"
S="${WORKDIR}/${PN}/python"
HTML_DOCS=( "${S}/../docs" )

src_prepare() {
	eapply --directory="${S%/*}" "${FILESDIR}"/${PN}-python3.diff
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
