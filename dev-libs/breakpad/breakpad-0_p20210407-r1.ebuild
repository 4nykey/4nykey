# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# DEPS: src/third_party/lss
MY_LSS="linux-syscall-support-fd00dbb"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
else
	MY_PV="c484031"
	SRC_URI="
		mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/stefanJi/${MY_LSS%-*}/tar.gz/${MY_LSS##*-}
		-> ${MY_LSS}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit autotools

DESCRIPTION="A crash-reporting system"
HOMEPAGE="https://chromium.googlesource.com/${PN}/${PN}"

LICENSE="BSD"
SLOT="0"

IUSE="processor tools"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
        "${FILESDIR}"/${PN}-fix-glibc-types.patch
)

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		EGIT_REPO_URI="https://chromium.googlesource.com/${MY_LSS%-*}" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_LSS}" \
			git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	ln -s ../../../${MY_LSS} src/third_party/lss
	sed -e '/docdir = /d' -i Makefile.am
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable processor)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}
