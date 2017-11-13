# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

MY_PN="mingw-w64"

inherit flag-o-matic autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/${MY_PN}/${MY_PN}"
else
	KEYWORDS="~amd64"
	SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${MY_PN}-release/${MY_PN}-v${PV}.tar.bz2"
	S="${WORKDIR}/${MY_PN}-v${PV}"
fi

DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="https://mingw-w64.org"

LICENSE="BSD"
SLOT="0"
IUSE="crosscompile_opts_headers-only idl libraries tools"
RESTRICT="strip"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}
crt_with() {
	just_headers && echo --without-$1 || echo --with-$1
}
crt_use_enable() {
	just_headers && echo --without-$2 || use_enable "$@"
}
crt_use_with() {
	just_headers && echo --without-$2 || use_with "$@"
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
	just_headers && return
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -m*=*
	unset AR RANLIB
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	if ! just_headers; then
		mkdir "${WORKDIR}/headers"
		pushd "${WORKDIR}/headers" > /dev/null
		"${S}/configure" \
			--host=${CTARGET} \
			--prefix="${T}/tmproot" \
			--with-headers \
			--without-crt \
			|| die
		popd > /dev/null
		append-cppflags "-I${T}/tmproot/include"
	fi

	econf \
		--host=${CTARGET} \
		--prefix=/usr/${CTARGET}/usr \
		--with-headers \
		--enable-sdk \
		$(crt_with crt) \
		$(crt_use_enable idl) \
		$(crt_use_with libraries all) \
		$(crt_use_with tools all) \
		--enable-lib64 \
		--enable-lib32
}

src_compile() {
	if ! just_headers; then
		emake -C "${WORKDIR}/headers" install
	fi
	default
}

src_install() {
	default
	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	rm -rf "${ED}/usr/share"

	is_crosscompile || return
	# gcc is configured to look at specific hard-coded paths for mingw #419601
	dosym usr /usr/${CTARGET}/mingw
	dosym usr/include /usr/${CTARGET}/include
	just_headers && return
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/lib32 /usr/${CTARGET}/lib32
}
