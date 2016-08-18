# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs
EGIT_REPO_URI="http://repo.or.cz/${PN}.git"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="43ca240"
	SRC_URI="
		${EGIT_REPO_URI}/snapshot/${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A linux framebuffer PDF viewer"
HOMEPAGE="http://repo.or.cz/fbpdf.git"

LICENSE="BSD"
SLOT="0"
IUSE="djvu mupdf poppler"
REQUIRED_USE="|| ( djvu mupdf poppler )"

RDEPEND="
	djvu? ( app-text/djvu )
	mupdf? (
		app-text/mupdf
		dev-lang/mujs
	)
	poppler? ( app-text/poppler[cxx] )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=( "${FILESDIR}"/${PN}-make.diff )

src_compile() {
	emake \
		$(usex djvu fbdjvu '') \
		$(usex mupdf fbpdf '') \
		$(usex poppler fbpdf2 '') \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin \
		$(usex djvu fbdjvu '') \
		$(usex mupdf fbpdf '') \
		$(usex poppler fbpdf2 '')
	dodoc README
}
