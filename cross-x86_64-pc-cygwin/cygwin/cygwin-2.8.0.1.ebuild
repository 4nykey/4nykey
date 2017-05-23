# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator toolchain-funcs flag-o-matic

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
# few headers are missing from binary pkg, so source tarball is needed
# for headers-only variant as well
SRC_URI="mirror://cygwin/x86_64/release/${PN}/"
SRC_URI="
	${SRC_URI}${PN}-${MY_PV}-src.tar.xz -> ${MY_P}-src.tar.xz
	crosscompile_opts_headers-only? (
		${SRC_URI}${PN}-devel/${PN}-devel-${MY_PV}.tar.xz ->
		${MY_P}.tar.xz
	)
"

LICENSE="NEWLIB LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip primaryuri"

S="${WORKDIR}/newlib-${PN}"

just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration; do not emerge this directly"
	fi
	just_headers && return
	PATCHES=(
		"${FILESDIR}"/${PN}-2.4.0-dont_regen_devices.cc.diff
	)
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -march=*
	strip-flags
}

src_unpack() {
	default
	local _p="newlib-${PN}-$(get_version_component_range -3)"
	unpack "${WORKDIR}"/${PN}-${MY_PV}.src/${_p}.tar.bz2
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
		# install prebuilt libs because of circular dep
		# gcc (+cxx) <-> cygwin
		doins -r "${WORKDIR}"/newlib-${PN}/newlib/libc/include "${WORKDIR}"/usr/{lib,include}
	else
		dodir /usr/${CTARGET}/usr/lib
		emake \
			DESTDIR="${D}" \
			tooldir="${EPREFIX}/usr/${CTARGET}/usr" \
			install
	fi
	# help gcc find its way
	dosym usr/lib /usr/${CTARGET}/lib
	dosym usr/include /usr/${CTARGET}/sys-include
}
