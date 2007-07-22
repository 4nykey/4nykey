# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_P="${PN}-$(replace_version_separator 2 -)"
DESCRIPTION="An MP3 reorganizer"
HOMEPAGE="http://omion.dyndns.org/mp3packer/mp3packer.html"
SRC_URI="http://omion.dyndns.org/mp3packer/${MY_P}_src.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/ocaml"
RDEPEND=""

src_compile() {
	emake OBJ_EXT=".o" || die
}

src_install() {
	dobin mp3packer
}
