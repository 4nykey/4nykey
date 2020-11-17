# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ca cs de es fr it ja ko nl no pl pt ru sr zh zh_TW"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/alessandrofrancesconi/${PN}.git"
	inherit git-r3
else
	MY_PV="cfbbd83"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/alessandrofrancesconi/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit toolchain-funcs l10n

DESCRIPTION="A GIMP plugin to apply a set of manipulations to groups of images"
HOMEPAGE="http://www.alessandrofrancesconi.it/projects/bimp/"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	media-gfx/gimp
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
DOCS=( CHANGELOG.md README.md )

src_compile() {
	tc-env_build emake -f "${FILESDIR}"/Makefile
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
