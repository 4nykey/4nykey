# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN}-core"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="aa9762b"
	SRC_URI="
		mirror://githubcl/${PN}/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://${PN}.github.io"

LICENSE="BSD"
SLOT="${PV%%.*}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""
DOCS=( C{ONTRIBUTORS,HANGES}.txt README.md )

src_prepare() {
	default
	sed -e '/MAKE.*getconf/d' -i "${S}"/Bootstrap.mak
}

src_compile() {
	local _pm="${PN}${SLOT} --cc=gcc --os=linux --verbose"
	declare -x CC="$(tc-getCC)"
	if has_version ${CATEGORY}/${PN}:${SLOT}; then
		${_pm} embed
	else
		_pm="${S}/bin/release/${_pm}"
		emake \
			-f Bootstrap.mak \
			CC="${CC} ${CFLAGS} ${LDFLAGS}" \
			linux
		emake \
			-C build/bootstrap \
			verbose=1
	fi
	${_pm} gmake
	sed -e '/ALL_LDFLAGS/s:-\<s\> ::' -i *.make || die
	emake verbose=1
}

src_install() {
	dobin bin/release/${PN}${SLOT}
	einstalldocs
}
