# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/impallari/Raleway.git"
	DOCS="README*"
else
	inherit vcs-snapshot font
	SRC_URI="
		mirror://github/impallari/Raleway/archive/96652ec1e3b62d0cc8f9d1a8349dfb3fa7cbf55a.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="Raleway is an elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""

FONT_SUFFIX="otf ttf"

src_prepare() {
	mv src/OTF/*.otf .
}
