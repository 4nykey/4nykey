# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit flag-o-matic vcs-snapshot eapi7-ver multilib-minimal

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Linux-like environment for Windows"
HOMEPAGE="https://cygwin.com/"
MY_PV="05cfd1a"
MY_PVB="$(ver_cut 1-3)"
if [[ -n ${PV%%*_p*} ]]; then
	MY_PV="${PN}-$(ver_cut 1-3 ${PV//./_})-release"
	MY_PVB+="-1"
else
	MY_PVB+="-$(ver_cut 5)"
fi
SRC_URI="
	!headers-only? (
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	headers-only? (
		abi_x86_32? (
			mirror://cygwin/x86/release/${PN}/${PN}-devel/${PN}-devel-${MY_PVB}.tar.xz
			-> ${P}-x86.tar.xz
		)
		abi_x86_64? (
			mirror://cygwin/x86_64/release/${PN}/${PN}-devel/${PN}-devel-${MY_PVB}.tar.xz
			-> ${P}-amd64.tar.xz
		)
	)
"

LICENSE="NEWLIB LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="headers-only"
RESTRICT="strip primaryuri"
HDEPEND="
	virtual/perl-Getopt-Long
"

just_headers() {
	use headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && S="${WORKDIR}" && return
	PATCHES=(
		"${FILESDIR}"/${PN}-2.4.0-dont_regen_devices.cc.diff
		"${FILESDIR}"/${PN}-multilib.diff
	)
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -march=*
	strip-flags
	local _b
	for _b in ar as dlltool ld nm obj{copy,dump} ranlib strip wind{mc,res}; do
		export ${_b^^}_FOR_TARGET=${CTARGET}-${_b}
	done
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

multilib_src_configure() {
	just_headers && return
	local myeconfargs=(
		--disable-werror
		--with-cross-bootstrap
		--infodir="${EPREFIX}/usr/${CTARGET}/usr/share/info"
		--with-windows-headers="${EPREFIX}/usr/${CTARGET}/usr/include/w32api"
		--with-windows-libs="${EPREFIX}/usr/${CTARGET}/usr/$(get_abi_LIBDIR)/w32api"
		--enable-libssp
		--disable-multilib
		--target=${CHOST%%-*}-${CTARGET#*-}
	)
	ECONF_SOURCE="${S}" \
	CC_FOR_TARGET="${CTARGET}-gcc $(get_abi_CFLAGS)" \
	CXX_FOR_TARGET="${CTARGET}-g++ $(get_abi_CFLAGS)" \
	econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	just_headers && return
	emake \
		CCWRAP_VERBOSE=1
}

multilib_src_install() {
	if just_headers; then
		local _d="${S}/${P}-${ABI}"
		insinto /usr/${CTARGET}/usr
		doins -r "${_d}"/include
		# install prebuilt libs because of circular dep gcc(+cxx) <-> cygwin
		insinto /usr/${CTARGET}/usr/$(get_abi_LIBDIR)
		doins -r "${_d}"/lib/.
	else
		dodir /usr/${CTARGET}/usr/lib
		# parallel install may overwrite winsup headers with newlib ones
		emake \
			-j1 \
			DESTDIR="${D}" \
			ABI=${ABI} \
			tooldir="${EPREFIX}/usr/${CTARGET}/usr" \
			libdir=$(get_abi_LIBDIR) \
			install
	fi
}

multilib_src_install_all() {
	# help gcc find its way
	use abi_x86_32 && dosym usr/${LIBDIR_x86} /usr/${CTARGET}/lib32
	use abi_x86_64 && dosym usr/${LIBDIR_amd64} /usr/${CTARGET}/lib64
	dosym usr/include /usr/${CTARGET}/sys-include
}
