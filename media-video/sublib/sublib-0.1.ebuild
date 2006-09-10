# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P}-src"
DESCRIPTION="SubLib is a library for managing movie subtitles, written in C#"
HOMEPAGE="http://sublib.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-arch/unzip"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README
	use doc && dohtml -A gif -r docs/
}
