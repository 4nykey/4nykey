# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
MY_PN="FiraGO"
MY_PV="${PV/.}"
MY_P="Download_Folder_${MY_PN}_${MY_PV}"
FONT_S=( ${MY_PN}_{O,T}TF_${MY_PV}/{Italic,Roman} )
inherit font-r1

DESCRIPTION="A continuation of FiraSans"
HOMEPAGE="https://bboxtype.com/typefaces/${MY_PN}"
SRC_URI="https://bboxtype.com/downloads/${MY_PN}/${MY_P}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	app-arch/unzip
"
S="${WORKDIR}/${MY_P}/Fonts"
DOCS=(
	${MY_PN}_${MY_PV}_CHANGE_LOG.rtf
)
