# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MULTILIB_COMPAT=( abi_x86_32 )
inherit vcs-snapshot
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b99ecb8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-single-r1 multilib-build
MY_R="robofab-62229c4"
MY_U="ufoNormalizer-1ed0111"
SRC_URI+="
	mirror://githubcl/robofab-developers/${MY_R%-*}/tar.gz/${MY_R##*-}
	-> ${MY_R}.tar.gz
	mirror://githubcl/unified-font-object/${MY_U%-*}/tar.gz/${MY_U##*-}
	-> ${MY_U}.tar.gz
"
RESTRICT="primaryuri"

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
	>=dev-python/fonttools-2.5[${PYTHON_USEDEP}]
"

src_unpack() {
	[[ ${PV} == *9999* ]] && git-r3_src_unpack
	vcs-snapshot_src_unpack
	mv -f \
		"${MY_U}"/normalization/ufonormalizer.py \
		"${MY_R}"/Lib/robofab \
		"${S}"/FDK/Tools/SharedData/FDKScripts/
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-makeotf.diff
		"${FILESDIR}"/${PN}-paths.diff
		"${FILESDIR}"/${PN}-inc.diff
		"${FILESDIR}"/${PN}-defcon.diff
	)
	rm -f "${S}"/FDK/Tools/linux/{AFDKOPython,setFDKPaths,ttx,ufonormalizer}
	rm -rf "${S}"/FDK/Tools/linux/Python
	local _d="${EROOT}usr/share/${PN}/SharedData/FDKScripts"
	sed \
		-e '/source.*setFDKPaths/d' \
		-e "s:\$AFDKO_Python \"\${AFDKO_Scripts}/:/usr/bin/env ${EPYTHON} \"${_d}/:" \
		-i "${S}"/FDK/Tools/linux/*
	default
}

src_compile() {
	tc-export CC CPP AR
	local _d
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS_x86} ${CFLAGS} -D__NO_STRING_INLINES" || return
	done
	find -path '*exe/linux/release/*' -exec mv -f {} "FDK/Tools/linux" \;
}

src_install() {
	local DOCS=( "FDK/Technical Documentation" )
	default
	dobin "${S}"/FDK/Tools/linux/*

	local _d="/usr/share/${PN}"
	insinto "${_d%}"
	doins -r "${S}"/FDK/Tools/SharedData

	python_optimize "${ED}"/${_d}/SharedData/FDKScripts
}
