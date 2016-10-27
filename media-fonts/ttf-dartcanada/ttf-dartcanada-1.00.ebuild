# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}"
inherit font-r1

DESCRIPTION="TrueType Unicode fonts (Enigmatic, Hindsight, Torquemada)"
HOMEPAGE="http://dartcanada.tripod.com/"
BASE_URI="http://dartcanada.tripod.com/Objets/Zips/"
SRC_URI="${BASE_URI}EnigUnic.zip ${BASE_URI}HindUnic.zip ${BASE_URI}TorqThUn.zip"

LICENSE="DSL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"

DOCS="*.txt"
FONT_SUFFIX="ttf TTF"
