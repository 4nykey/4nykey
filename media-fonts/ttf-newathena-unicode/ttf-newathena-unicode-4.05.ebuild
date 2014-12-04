# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator unpacker

MY_P="NAU$(delete_all_version_separators)styles"
S="${WORKDIR}/${MY_P}"

inherit font

DESCRIPTION="New Athena Unicode is a freeware multilingual font distributed by the American Philological Association"
HOMEPAGE="http://socrates.berkeley.edu/~pinax/greekkeys/NAUdownload.html"
SRC_URI="http://socrates.berkeley.edu/~pinax/greekkeys/fonts/${MY_P}.zip"
RESTRICT="primaryuri"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""

DOCS="*.rtf"
FONT_SUFFIX="ttf"
