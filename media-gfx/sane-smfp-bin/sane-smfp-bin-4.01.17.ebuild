# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils multilib

DESCRIPTION="SANE backend for Samsung MFP devices"
HOMEPAGE="http://www.samsung.com"
SRC_URI="http://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-${PV}.tar.gz"

LICENSE="EULA"
LICENSE_URL="http://www.samsung.com/us/common/software_eula.html"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="primaryuri strip"

DEPEND=""
RDEPEND="
	virtual/libstdc++:3.3
	media-gfx/sane-backends
"

S="${WORKDIR}/cdroot/Linux"

src_install() {
	local _arch="i386" _libd="$(get_libdir)"
	use amd64 && _arch="x86_64"

	dolib ${_arch}/at_root/usr/${_libd}/libmfp.so.1.0.1
	dosym libmfp.so.1.0.1 /usr/${_libd}/libmfp.so.1
	dosym libmfp.so.1.0.1 /usr/${_libd}/libmfp.so
	dosbin ${_arch}/at_root/usr/sbin/smfpd

	insinto /etc/sane.d
	doins noarch/at_root/etc/sane.d/smfp.conf

	exeinto /usr/${_libd}/sane/
	doexe ${_arch}/at_root/usr/${_libd}/sane/libsane-smfp.so.1.0.1
	dosym libsane-smfp.so.1.0.1 /usr/${_libd}/sane/libsane-smfp.so.1
	dosym libsane-smfp.so.1.0.1 /usr/${_libd}/sane/libsane-smfp.so

	mkdir -p "${D}"/etc/sane.d/dll.d
	echo smfp > "${D}"/etc/sane.d/dll.d/${PN}
}
