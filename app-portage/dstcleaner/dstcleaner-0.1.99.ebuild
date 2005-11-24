# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Portage distfiles and workdirs cleaner"
HOMEPAGE="http://unixware.sourceforge.net/dstcleaner"
SRC_URI="http://unixware.sourceforge.net/dstcleaner/dstsrc/${P/99/1}.tar.gz
	http://unixware.sourceforge.net/dstcleaner/dstclr/src/${P}.pl.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8
		>=dev-util/dialog-0.9"
DEPEND="${RDEPEND}"

src_install() {
	dosbin ${WORKDIR}/${P}.pl
	dodoc ${WORKDIR}/README ${WORKDIR}/ChangeLog
	dosym /usr/sbin/${P}.pl /usr/sbin/${PN}
}

pkg_postinst() {
	einfo
	einfo "Please, see the README before using dstcleaner."
	einfo
}
