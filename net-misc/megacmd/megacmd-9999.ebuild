# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="A command-line client for mega.co.nz storage service"
HOMEPAGE="https://github.com/t3rm1n4l/megacmd/"
EGIT_REPO_URI="https://github.com/t3rm1n4l/megacmd.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/go
"
RDEPEND=""

src_install() {
	dobin ${PN}
	dodoc README.md
}
