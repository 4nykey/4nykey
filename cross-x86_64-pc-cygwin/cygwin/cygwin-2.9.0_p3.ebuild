# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic vcs-snapshot eapi7-ver

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="Linux-like environment for Windows"
HOMEPAGE="https://cygwin.com/"
MY_ARCH="${CTARGET%-pc-cygwin}"
MY_ARCH="${MY_ARCH/i686/x86}"
MY_PV="05cfd1a"
MY_PB="${P}-${MY_ARCH}"
MY_PVB="$(ver_cut 1-3)"
if [[ -n ${PV%%*_p*} ]]; then
	MY_PV="${PN}-$(ver_cut 1-3 ${PV//./_})-release"
	MY_PVB+="-1"
else
	MY_PVB+="-$(ver_cut 5)"
fi
SRC_URI="
	!crosscompile_opts_headers-only? (
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	crosscompile_opts_headers-only? (
		mirror://cygwin/${MY_ARCH}/release/${PN}/${PN}-devel/${PN}-devel-${MY_PVB}.tar.xz
		-> ${MY_PB}.tar.xz
	)
"

LICENSE="NEWLIB LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip primaryuri"

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && S="${WORKDIR}"/${MY_PB} && return
	PATCHES=(
		"${FILESDIR}"/${PN}-2.4.0-dont_regen_devices.cc.diff
	)
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -march=*
	strip-flags
}

src_prepare() {
	default
	just_headers && return
	sed \
		-e '/INSTALL_LICENSE="install-license"/d' \
		-e 's:\(subdirs="\$subdirs cygwin\).*":\1":' \
		-i winsup/configure
	sed \
		-e 's:-Werror::' \
		-e 's:install-man install-ldif::' \
		-e 's:\$(DESTDIR)\$(bindir):$(DESTDIR)$(tooldir)/bin:' \
		-i winsup/cygwin/Makefile.in
}

src_configure() {
	just_headers && return
	econf \
		--disable-werror \
		--with-cross-bootstrap \
		--infodir="${EPREFIX}/usr/${CTARGET}/usr/share/info" \
		--with-windows-headers="${EPREFIX}/usr/${CTARGET}/usr/include/w32api" \
		--with-windows-libs="${EPREFIX}/usr/${CTARGET}/usr/lib/w32api"
}

src_compile() {
	just_headers || emake CCWRAP_VERBOSE=1
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr
		# install prebuilt libs because of circular dep gcc(+cxx) <-> cygwin
		doins -r "${S}"/{include,lib}
	else
		dodir /usr/${CTARGET}/usr/lib
		# parallel install may overwrite winsup headers with newlib ones
		emake \
			-j1 \
			DESTDIR="${D}" \
			tooldir="${EPREFIX}/usr/${CTARGET}/usr" \
			install
	fi
	# help gcc find its way
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/include /usr/${CTARGET}/sys-include
}
