# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools subversion

DESCRIPTION="WavPack hybrid audio compression"
HOMEPAGE="http://www.wavpack.com/"
ESVN_REPO_URI="http://svn.slomosnail.de/wavpack/trunk"
ESVN_BOOTSTRAP="eautoreconf"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mmx"

RDEPEND="
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
"
src_compile() {
	econf \
		$(use_enable mmx) \
		|| die
	emake || die
}

src_install() {
	einstall || die
	dodoc *.txt
}
