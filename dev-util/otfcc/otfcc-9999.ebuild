# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/caryll/${PN}.git"
	EGIT_BRANCH=releases
else
	MY_PV="v$(ver_rs 3 '-')"
	[[ -z ${PV%%*_*} ]] && inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/caryll/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="An optimized OpenType builder and inspector"
HOMEPAGE="https://github.com/caryll/otfcc"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

BDEPEND="
	dev-util/premake:5
"

src_configure() {
	MAKE=premake5 \
	MAKEOPTS="--cc=$(tc-get-compiler-type) --os=linux --verbose" \
		emake gmake
	sed \
		-e 's: -\(O3\|\<s\>\)::g' \
		-i build/gmake/*.make
}

src_compile() {
	emake -C build/gmake \
		CC="$(tc-getCC)" \
		config=release_${ARCH/amd/x} \
		verbose=1
}

src_install() {
	dobin bin/release-${ARCH/amd/x}/${PN}*
	einstalldocs
}
