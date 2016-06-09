# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
else
	SRC_URI="http://${PN}.googlecode.com/files/${PN}-src-${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi

DESCRIPTION="A set of fontforge scripts for producing fonts"
HOMEPAGE="https://code.google.com/p/font-helpers"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="primaryuri"

src_install() {
	insinto /usr/share/${PN}
	doins *.{ff,py}
	dodoc ChangeLog* README*
}
