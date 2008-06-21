# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="An implementation of the line breaking algorithm"
HOMEPAGE="http://vimgadgets.sourceforge.net"
ECVS_SERVER="vimgadgets.cvs.sourceforge.net:/cvsroot/vimgadgets"
ECVS_MODULE="common/tools/linebreak"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

src_compile() {
	local myconf="release"
	use debug && myconf="debug"
	emake \
		DEBUG="${S}" RELEASE="${S}" \
		RELFLAGS="${CFLAGS}" \
		${myconf} \
		|| die
}

src_install() {
	dolib.a liblinebreak.a
	insinto /usr/include
	doins linebreak.h
	dodoc ChangeLog README
}
