# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial

DESCRIPTION="Btrfs utility programs"
HOMEPAGE="http://oss.oracle.com/projects/btrfs/"
EHG_REPO_URI="http://oss.oracle.com/mercurial/mason/${PN}"

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
	mercurial_fetch ${EHG_REPO_URI} ${PF}
	cd ${S}
	epatch "${FILESDIR}"/${PN}*.diff
}

src_install() {
	emake DESTDIR=${D} bindir=/sbin install || die
	dosym btrfsck /sbin/fsck.btrfs
	dodoc INSTALL
}
