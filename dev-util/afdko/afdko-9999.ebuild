# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="cbc6d5c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
RESTRICT="primaryuri"

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/fontPens[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.25[${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
	dev-python/ufoNormalizer[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"
DOCS=(
{README,NEWS}.rst
html
pdf
afdko/FDKReleaseNotes.txt
)

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-ar.diff
		"${FILESDIR}"/${PN}-ufo3.diff
		"${FILESDIR}"/${PN}-scripts.diff
		"${FILESDIR}"/${PN}-autohint.diff
	)
	sed \
		-e "/AFDKO_Python=/s:=.*:=${PYTHON}:" \
		-e "/AFDKO_Scripts=/s:=.*\.\./:=${EROOT}usr/lib/${PN}/:" \
		-i afdko/Tools/linux/setFDKPaths
	sed \
		-e '/^[ ]\+except (MakeOTFOptionsError.*):$/,/^[ ]\+pass$/d' \
		-i afdko/Tools/SharedData/FDKScripts/MakeOTF.py
	rm -f afdko/Tools/linux/{ufonormalizer,AFDKOPython}
	mkdir html pdf
	mv -f afdko/{.,Technical\ Documentation}/*.html html/
	mv -f afdko/Technical\ Documentation/*.pdf pdf/
	default
}

src_compile() {
	tc-export CC CPP AR
	local _d
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS}" || return
	done
	find -path '*exe/linux/release/*' -execdir mv -f -t "${S}"/afdko/Tools/linux {} +
}

src_install() {
	local _d="/usr/lib/${PN}"
	insinto "${_d}"

	doins -r afdko/Tools/SharedData
	python_optimize "${ED}"${_d}/SharedData

	exeinto "${_d}/bin"
	doexe afdko/Tools/linux/*

	dodir /etc/env.d
	cat > "${T}"/10${PN} <<- EOF
		PATH="${EPREFIX}${_d}/bin"
		ROOTPATH="${EPREFIX}${_d}/bin"
	EOF
	doenvd "${T}"/10${PN}

	einstalldocs
}
