# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs linux-mod

DESCRIPTION="An entirely re-designed and re-implemented Unionfs."
HOMEPAGE="http://aufs.sourceforge.net/"
ECVS_SERVER="aufs.cvs.sourceforge.net:/cvsroot/aufs"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

MODULE_NAMES="aufs(fs:)"
BUILD_TARGETS="all"
MAKEOPTS="-j1"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KDIR=${KV_DIR} -f local.mk"
}

src_install() {
	linux-mod_src_install
	exeinto /sbin
	exeopts -m0500
	doexe mount.aufs umount.aufs auplink aulchown 
	newexe util/unionctl aunionctl
	doman aufs.5
}
