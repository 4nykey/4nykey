# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cygwin/cygwin-1.5.25.15.ebuild,v 1.1 2008/11/28 09:21:44 vapier Exp $

EAPI="5"

inherit versionator toolchain-funcs flag-o-matic unpacker

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

MY_PV="$(replace_version_separator 3 '-')"
MY_P="${P}_x64"
DESCRIPTION="Linux-like environment for Windows"
HOMEPAGE="http://cygwin.com/"
BASE_URI="mirror://cygwin/x86_64/release/"
# few headers are missing from binary pkg, so source tarball is needed
# for headers-only variant as well
SRC_URI="
	${BASE_URI}${PN}/${PN}-${MY_PV}-src.tar.xz -> ${MY_P}-src.tar.xz
	crosscompile_opts_headers-only? (
		${BASE_URI}${PN}/${PN}-devel/${PN}-devel-${MY_PV}.tar.xz ->
		${MY_P}.tar.xz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip primaryuri"

DEPEND="
	$(unpacker_src_uri_depends)
"

S="${WORKDIR}/newlib-${PN}"

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && return
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -march=*
	strip-flags
}

src_unpack() {
	default
	local _p="newlib-${PN}-$(get_version_component_range -3)"
	unpacker ${WORKDIR}/${PN}-${MY_PV}.src/${_p}.tar.bz2
}

src_prepare() {
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
	epatch "${FILESDIR}"/${PN}*.diff
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
		# install prebuilt libs because of circular dep
		# gcc (+cxx) <-> cygwin
		doins -r "${WORKDIR}"/newlib-${PN}/newlib/libc/include "${WORKDIR}"/usr/{lib,include}
	else
		emake -j1 \
			DESTDIR="${D}" \
			tooldir="${EPREFIX}/usr/${CTARGET}/usr" \
			install
	fi
	# help gcc find its way
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/include /usr/${CTARGET}/sys-include
}
