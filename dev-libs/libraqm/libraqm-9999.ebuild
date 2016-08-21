# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HOST-Oman/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="201db95"
	SRC_URI="
		mirror://githubcl/HOST-Oman/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools

DESCRIPTION="A library for complex text layout"
HOMEPAGE="https://github.com/HOST-Oman/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="apidocs"

RDEPEND="
	media-libs/freetype:2
	media-libs/harfbuzz
	dev-libs/fribidi
"
DEPEND="
	${RDEPEND}
	apidocs? ( dev-util/gtk-doc )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable apidocs gtk-doc)
}
