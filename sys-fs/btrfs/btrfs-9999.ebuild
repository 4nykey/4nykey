# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial linux-mod

DESCRIPTION="Btrfs kernel module"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
EHG_REPO_URI="http://oss.oracle.com/mercurial/mason/${PN}"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

MODULE_NAMES="btrfs(fs:)"
BUILD_TARGETS="all"
MODULESD_BTRFS_DOCS="INSTALL TODO"

pkg_setup() {
	linux-mod_pkg_setup
	if ! linux_chkconfig_present LIBCRC32C; then
		eerror "${PN} requires CRC32c (CONFIG_LIBCRC32C) as module or compiled in"
		eerror "Library routines -> "
		eerror "	CRC32c (Castagnoli, et al) Cyclic Redundancy-Check"
		die "libcrc32c support not detected."
	fi
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}
