# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Btrfs utility programs"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
SRC_URI="http://oss.oracle.com/projects/btrfs/dist/files/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	sys-fs/e2fsprogs
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	unpack ${A}
	sed -i ${S}/Makefile -e 's:^CFLAGS = :CFLAGS += :'
}

src_install() {
	emake DESTDIR=${D} bindir=/sbin install || die
	dosym btrfsck /sbin/fsck.btrfs
	dodoc INSTALL
}
