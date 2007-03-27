# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="TrueType Unicode fonts (Enigmatic, Hindsight, Torquemada)"
HOMEPAGE="http://dartcanada.tripod.com/"
BASE_URI="http://dartcanada.tripod.com/Objets/Zips/"
SRC_URI="${BASE_URI}EnigUnic.zip ${BASE_URI}HindUnic.zip ${BASE_URI}TorqThUn.zip"
S="${WORKDIR}"

LICENSE="DSL"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="*.txt"
FONT_SUFFIX="ttf TTF"
FONT_S="${S}"
