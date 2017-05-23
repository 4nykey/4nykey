# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic unpacker

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="MinGW-w64 Windows API for Cygwin"
HOMEPAGE="http://cygwin.com/"
BASE_URI="mirror://cygwin/x86_64/release"
MY_H="${PN}-headers-${PV}-1"
MY_R="${PN}-runtime-${PV}-1"
MY_P="${P}-x64"
SRC_URI="
	!crosscompile_opts_headers-only? (
		${BASE_URI}/${PN}-runtime/${MY_R}-src.tar.xz -> ${MY_P}_src.tar.xz
	)
	crosscompile_opts_headers-only? (
		${BASE_URI}/${PN}-headers/${MY_H}.tar.xz -> ${MY_P}_inc.tar.xz
		${BASE_URI}/${PN}-runtime/${MY_R}.tar.xz -> ${MY_P}_lib.tar.xz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip primaryuri"
S="${WORKDIR}/mingw-w64"

DEPEND=""

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && return
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -m*=*
	strip-flags
}

src_unpack() {
	mkdir -p "${S}"
	default
	just_headers || unpacker "${WORKDIR}"/${MY_R}.src/mingw-w64-${PV}.tar.bz2
}

src_configure() {
	just_headers && return
	econf \
		--enable-w32api \
		--host=${CTARGET} \
		--with-sysroot="${EPREFIX}/usr/${CTARGET}"
}

src_compile() {
	just_headers && return
	default
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr
		doins -r "${WORKDIR}"/usr/{lib,include}
	else
		emake \
			DESTDIR="${D}usr/${CTARGET}" \
			install
	fi
}
