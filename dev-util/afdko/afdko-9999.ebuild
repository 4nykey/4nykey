# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-r1
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/booleanOperations
	dev-python/MutatorMath
	dev-python/ufoNormalizer
	>=dev-python/fonttools-2.5
"
PATCHES=( "${FILESDIR}"/${PN}*.diff )
DOCS=( "FDK/Technical Documentation" )

pkg_setup() {
	python_setup
}

src_prepare() {
	rm -f "FDK/Tools/linux/AFDKOPython"
	rm -rf "FDK/Tools/linux/Python"
	default
}

src_compile() {
	tc-export CC
	local x
	find -path '*/linux/gcc/release/Makefile' -printf '%h\n'|while read x; do
		emake -C "${x}" || die
	done
	find -path '*exe/linux/release/*' -exec mv -f {} "FDK/Tools/linux" \;
}

src_install() {
	default
	local FDK_EXE="/usr/$(get_libdir)/${PN}/FDK/Tools/linux"
	printf \
		'export FDK_EXE="%s"\nexport PATH="${FDK_EXE}:${PATH}"\n' \
		"${FDK_EXE}" > "${T}"/${PN}
	insinto /etc
	doins "${T}"/${PN}

	insinto "${FDK_EXE%/*}"
	doins -r "${S}"/FDK/Tools/SharedData
	exeinto "${FDK_EXE}"
	doexe "${S}"/FDK/Tools/linux/*
	dosym "${PYTHON}" "${FDK_EXE}"/AFDKOPython
	python_optimize "${ED}"/usr/$(get_libdir)/${PN}/FDK/Tools/SharedData/FDKScripts
}
