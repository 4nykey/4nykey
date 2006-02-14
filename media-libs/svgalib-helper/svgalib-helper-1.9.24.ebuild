# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.9.24.ebuild,v 1.1 2006/02/07 03:01:43 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs linux-mod

MY_PN="${PN/-helper/}"
MY_P="${P/-helper/}"
MY_PF="${PF/-helper/}"
S="${WORKDIR}/${MY_PF}"

DESCRIPTION="A library for running svga graphics on the console"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.arava.co.il/matan/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

RDEPEND="=${MY_PF}"

MODULE_NAMES="svgalib_helper(misc:${S}/kernel/svgalib_helper)"
BUILD_TARGETS="default"
MODULESD_SVGALIB_HELPER_ADDITIONS="probeall  /dev/svga  svgalib_helper"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Misc makefile clean ups
	epatch "${FILESDIR}"/${MY_PN}-1.9.23-gentoo.patch

	# Get it to work with kernel 2.6
	epatch "${FILESDIR}"/${MY_PN}-1.9.24-linux2.6.patch

	# -fPIC does work for lrmi, see bug #51698
	epatch "${FILESDIR}"/${MY_PN}-1.9.19-pic.patch

	# Don't let the ebuild screw around with ld.so.conf #64829
	epatch "${FILESDIR}"/${MY_PN}-1.9.19-dont-touch-ld.conf.patch

	# Don't strip stuff, let portage do it
	sed -i '/^INSTALL_PROGRAM/s: -s : :' Makefile.cfg
}
