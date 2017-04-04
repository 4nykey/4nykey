# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ca cs de es fr it ja ko no pl pt ru zh zh_TW"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/alessandrofrancesconi/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/alessandrofrancesconi/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs l10n

DESCRIPTION="A GIMP plugin to apply a set of manipulations to groups of images"
HOMEPAGE="http://www.alessandrofrancesconi.it/projects/bimp/"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	media-gfx/gimp:2
	dev-libs/libpcre:3
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=( "${FILESDIR}"/${PN}_build.diff )
DOCS=( CHANGELOG.md README.md )

src_compile() {
	local _pc="$(tc-getPKG_CONFIG)" _d="gimpui-2.0 libpcre"
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} $(${_pc} --cflags ${_d})" \
		LIBS="$(${_pc} --libs ${_d})"
}

src_install() {
	local _p="gimp20-plugin-bimp"
	mymo() {
		cp bimp-locale/${1}/LC_MESSAGES/${_p}.mo ${1}.mo
		MOPREFIX="${_p}" domo ${1}.mo
	}
	exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
	doexe bimp
	l10n_for_each_locale_do mymo
	einstalldocs
}
