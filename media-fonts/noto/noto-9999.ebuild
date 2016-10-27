# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
else
	inherit vcs-snapshot
	MY_PV="86b2e55"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}-fonts/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	cjk emoji +binary pipeline
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE="pipeline? ( binary )"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND=""
RDEPEND="
	cjk? ( media-fonts/noto-cjk )
	emoji? ( media-fonts/noto-emoji )
	!binary? ( media-fonts/noto-source )
	!media-fonts/croscorefonts
"

FONT_SUFFIX="ttf"
FONT_S=( hinted )

pkg_setup() {
	use pipeline || return
	use font_types_otf && FONT_SUFFIX+=" otf"
	FONT_S+=( alpha{,/OTF}/from-pipeline )
}
