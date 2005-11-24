# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.9.23.ebuild,v 1.1 2005/11/01 03:41:32 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs linux-mod

MY_PN="${PN/-helper/}"
MY_P="${P/-helper/}"
MY_PF="${PF/-helper/}"

DESCRIPTION="A library for running svga graphics on the console (kernel module only)"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.arava.co.il/matan/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

DEPEND="=${MY_PF}"

MODULE_NAMES="svgalib_helper(misc:${S}/kernel/svgalib_helper)"
BUILD_TARGETS="default"
MODULESD_SVGALIB_HELPER_ADDITIONS="probeall  /dev/svga  svgalib_helper"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KDIR=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Misc makefile clean ups
	epatch "${FILESDIR}"/${MY_PN}-1.9.23-gentoo.patch

	# Get it to work with kernel 2.6
	epatch "${FILESDIR}"/${MY_PN}-1.9.21-linux2.6.patch

	# -fPIC does work for lrmi, see bug #51698
	epatch "${FILESDIR}"/${MY_PN}-1.9.19-pic.patch

	# Don't let the ebuild screw around with ld.so.conf #64829
	epatch "${FILESDIR}"/${MY_PN}-1.9.19-dont-touch-ld.conf.patch

	# Don't strip stuff, let portage do it
	sed -i '/^INSTALL_PROGRAM/s: -s : :' Makefile.cfg
}

src_compile() {
	export CC=$(tc-getCC)
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
	[[ ${ROOT} != "/" ]] && return 0

	if [[ -e /dev/.devfsd ]] ; then
		ebegin "Restarting devfsd to reread devfs rules"
		killall -HUP devfsd
		eend $?
	elif [[ -e /dev/.udev ]] ; then
		ebegin "Restarting udev to reread udev rules"
		udevstart
		eend $?
	fi
}
