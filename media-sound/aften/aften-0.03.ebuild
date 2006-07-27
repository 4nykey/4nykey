# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Aften is an open-source A/52 (AC-3) audio encoder"
HOMEPAGE="http://jbr.homelinux.org/aften/"
SRC_URI="http://jbr.homelinux.org/aften/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mmx debug"

DEPEND=""
RDEPEND=""

src_compile() {
	local myconf
	use mmx || myconf="${myconf} --disable-mmx"
	use debug || myconf="${myconf} --disable-debug"
	./configure \
		--disable-strip \
		--disable-opts \
		${myconf} || die
	emake || die
}

src_install() {
	dobin aften util/wav{info,rms}
	dodoc Changelog README
}
