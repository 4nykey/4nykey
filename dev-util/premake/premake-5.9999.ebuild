# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}-core"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="bf1ea24"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV//_/-}"
	SRC_URI="
		mirror://githubcl/${PN}/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubraw/${PN}/${MY_PN}/${MY_PV}/Bootstrap.mak
		-> premake_bootstrap-${MY_PV}.mak
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="A makefile generation tool"
HOMEPAGE="https://${PN}.github.io"

LICENSE="BSD"
SLOT="${PV%%.*}"
IUSE=""

RDEPEND=""
DEPEND=""
DOCS=( C{ONTRIBUTORS,HANGES}.txt README.md )

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && \
		cp "${DISTDIR}"/premake_bootstrap-${MY_PV}.mak Bootstrap.mak
	sed \
		-e '/MAKE.*getconf/d' \
		-e 's:--to=:--no-curl --no-zlib &:' \
		-i "${S}"/Bootstrap.mak
}

src_compile() {
	local _m="${S}/bin/release/${PN}${SLOT}" \
		_o="--cc=$(tc-get-compiler-type) --os=linux --verbose"
	declare -x CC="$(tc-getCC)"
	emake \
		-f Bootstrap.mak \
		CC="${CC} ${CFLAGS} ${LDFLAGS}" \
		linux
	emake \
		-C build/bootstrap \
		verbose=1
	MAKE=${_m} MAKEOPTS="${_o}" emake gmake
	sed \
		-e 's: -\(O3\|\<s\>\)::g' \
		-i *.make
	emake verbose=1
}

src_test() {
	bin/release/premake${SLOT} test || die
}

src_install() {
	dobin bin/release/${PN}${SLOT}
	einstalldocs
}
