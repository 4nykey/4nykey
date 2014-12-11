# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/impallari/Raleway.git"
	DOCS="README*"
else
	S="${WORKDIR}/${PN}-family-v${PV}"
	inherit unpacker font
	SRC_URI="http://www.impallari.com/media/uploads/prosources/update-100-source.zip"
	RESTRICT="primaryuri"
	DEPEND="$(unpacker_src_uri_depends)"
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
