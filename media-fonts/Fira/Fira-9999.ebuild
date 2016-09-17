# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/mozilla/${PN}.git"
	DOCS="README*"
else
	inherit font vcs-snapshot
	BASE_URI="http://www.carrois.com/downloads/"
	SRC_URI="
		mirror://githubcl/mozilla/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	DOCS="*.md"
fi

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!media-fonts/fira-mono
	!media-fonts/fira-sans
"
FONT_SUFFIX="otf"
FONT_S="${S}/otf"
