# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Sorts Mill Type Inspector Generator"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-scheme/guile-2:12
"
DEPEND="
	${RDEPEND}
	sys-apps/help2man
"

src_prepare() {
	default
	eautoreconf
}
