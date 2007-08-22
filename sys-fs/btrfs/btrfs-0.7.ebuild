# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

DESCRIPTION="Btrfs kernel module"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
SRC_URI="http://oss.oracle.com/projects/btrfs/dist/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

MODULE_NAMES="btrfs(fs:)"
BUILD_PARAMS="-C ${KV_DIR} M=${S}"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	if ! linux_chkconfig_present LIBCRC32C; then
		eerror "${PN} requires CRC32c (CONFIG_LIBCRC32C) as module or compiled in"
		eerror "Library routines -> "
		eerror "	CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
		die "libcrc32c support not detected."
	fi
}
