# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils
if [[ "${PV%9999}" != "${PV}" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jrbasso/gistit.git"
else
	SRC_URI="
		mirror://github/jrbasso/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An application to create github gists from console"
HOMEPAGE="http://gistit.herokuapp.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-misc/curl
	dev-libs/jansson
"
RDEPEND="
	${DEPEND}
"
AUTOTOOLS_AUTORECONF="1"
