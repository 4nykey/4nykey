# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
MULTILIB_COMPAT=( abi_x86_32 )
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
inherit python-single-r1 multilib-build

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-python/ufoNormalizer[${PYTHON_USEDEP}]
	dev-python/robofab[${PYTHON_USEDEP}]
	>=dev-python/fonttools-2.5[${PYTHON_USEDEP}]
"
PATCHES=(
	"${FILESDIR}"/${PN}-makeotf.diff
	"${FILESDIR}"/${PN}-paths.diff
	"${FILESDIR}"/${PN}-inc.diff
)
DOCS=( "FDK/Technical Documentation" )

src_prepare() {
	rm -f "${S}"/FDK/Tools/linux/{AFDKOPython,setFDKPaths,ttx,ufonormalizer}
	rm -rf "${S}"/FDK/Tools/linux/Python
	local _d="${EROOT}usr/share/${PN}/SharedData/FDKScripts"
	sed \
		-e '/source.*setFDKPaths/d' \
		-e "s:\$AFDKO_Python \"\${AFDKO_Scripts}/:/usr/bin/env ${EPYTHON} \"${_d}/:" \
		-i "${S}"/FDK/Tools/linux/*
	default
	tc-export CC CPP AR
}

src_compile() {
	local _d
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS_x86} ${CFLAGS} -D__NO_STRING_INLINES" || die
	done
	find -path '*exe/linux/release/*' -exec mv -f {} "FDK/Tools/linux" \;
}

src_install() {
	default
	dobin "${S}"/FDK/Tools/linux/*

	local _d="/usr/share/${PN}"
	insinto "${_d%}"
	doins -r "${S}"/FDK/Tools/SharedData

	python_optimize "${ED}"/${_d}/SharedData/FDKScripts
}
