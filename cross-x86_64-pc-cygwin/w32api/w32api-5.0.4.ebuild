# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit flag-o-matic vcs-snapshot multilib-build

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

DESCRIPTION="MinGW-w64 Windows API for Cygwin"
HOMEPAGE="http://cygwin.com/"
MY_H="${PN}-headers-${PV}-1"
MY_R="${PN}-runtime-${PV}-1"
MY_PN="mingw-w64"
MY_P="${MY_PN}-v${PV}"
SRC_URI="
	!headers-only? (
		mirror://sourceforge/${MY_PN}/${MY_PN}/${MY_PN}-release/${MY_P}.tar.bz2
	)
	headers-only? (
		mirror://cygwin/x86_64/release/${PN}-headers/${MY_H}.tar.xz
		abi_x86_32? (
			mirror://cygwin/x86/release/${PN}-runtime/${MY_R}.tar.xz
			-> ${MY_R}-x86.tar.xz
		)
		abi_x86_64? (
			mirror://cygwin/x86_64/release/${PN}-runtime/${MY_R}.tar.xz
			-> ${MY_R}-amd64.tar.xz
		)
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="headers-only"
RESTRICT="strip primaryuri"
S="${WORKDIR}"
DEPEND=""

just_headers() {
	use headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
	just_headers && return
	S="${WORKDIR}/${MY_P}"
	CHOST=${CTARGET} strip-unsupported-flags
	filter-flags -m*=*
	strip-flags
	unset AR RANLIB
}

src_prepare() {
	default
	if ! just_headers; then
		eapply "${FILESDIR}"/${PN}-wcstombs.diff
		mkdir "${T}"/tmproot
		cp -r "${EPREFIX}"/usr/${CTARGET}/usr/include "${T}"/tmproot
		rm -rf "${T}"/tmproot/include/w32api
	fi
}

src_configure() {
	just_headers && return
	local myeconfargs=(
		--host=${CTARGET}
		--enable-w32api
		--with-headers
		$(use_enable abi_x86_32 lib32)
		$(use_enable abi_x86_64 lib64)
	)

	# don't use headers from previously installed version
	mkdir -p "${WORKDIR}"/headers
	cd "${WORKDIR}"/headers
	ECONF_SOURCE="${S}" \
		econf "${myeconfargs[@]}" \
		--prefix="${T}/tmproot" \
		--without-crt

	cd "${S}"
	econf "${myeconfargs[@]}" \
		--with-crt \
		--with-sysroot="${T}/tmproot"
}

src_compile() {
	just_headers && return
	emake -C "${WORKDIR}/headers" install
	default
}

src_install() {
	if just_headers; then
		local _a
		for _a in ${MULTILIB_ABIS}; do
			insinto /usr/${CTARGET}/usr/$(get_abi_LIBDIR ${_a})
			doins -r ${MY_R}-${_a}/lib/${PN}/.
			insinto /usr/${CTARGET}/usr
			doins -r ${MY_R}-${_a}/include
		done
		doins -r ${MY_H}/include
	else
		emake \
			DESTDIR="${D}usr/${CTARGET}" \
			lib32dir="/usr/${LIBDIR_x86}" \
			lib64dir="/usr/${LIBDIR_amd64}" \
			install
	fi
	use abi_x86_32 && dosym . /usr/${CTARGET}/usr/${LIBDIR_x86}/${PN}
	use abi_x86_64 && dosym . /usr/${CTARGET}/usr/${LIBDIR_amd64}/${PN}
}
