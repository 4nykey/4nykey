# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.eu/ https://github.com/dtschump/CImg"
SRC_URI="mirror://githubcl/dtschump/CImg/tar.gz/v.${PV} -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="|| ( CeCILL-2 CeCILL-C )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_install() {
	dodoc README.txt
	doheader CImg.h
	use doc && dodoc -r html
	use examples || return
	insinto /usr/share/${PN}
	doins -r examples
}
