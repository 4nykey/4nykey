# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	inherit vcs-snapshot
	MY_PVR="${PV}R-ro/1.030R-it"
	MY_PVS="${MY_PVR//R}"
	SRC_URI="
		!afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PVR}
			-> ${PN}-${MY_PVR/\//-}.tar.gz
		)
		afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PVS}
			-> ${PN}-${MY_PVS/\//-}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Monospaced font family for user interface and coding environments"
HOMEPAGE="http://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="afdko"

DEPEND="
	afdko? ( media-gfx/afdko )
"
RDEPEND=""

FONT_SUFFIX="otf ttf"
DOCS="README.md"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex afdko master release)"
	else
		local _v
		_v=$(usex afdko ${MY_PVS} ${MY_PVR})
		_v="${_v/\//-}"
		S="${WORKDIR}/${PN}-${_v}"
		FONT_S="${S}"
	fi
	font_pkg_setup
}

src_prepare() {
	default
	use !afdko && return 0
	sed \
		-e 's:makeotf.*:& 2>> "${T}"/makeotf.log || die "failed to build $family-$w, see ${T}/makeotf.log":' \
		-e 's:addSVG=.*:addSVG=$(find "${S}" -name addSVGtable.py):' \
		-i "${S}"/build.sh
}

src_compile() {
	if use !afdko; then
		find "${S}" -mindepth 2 -name '*.[ot]tf' -exec mv -f {} "${S}" \;
	else
		source ${EROOT}etc/afdko
		source "${S}"/build.sh
		find "${S}" -path '*/target/[OT]TF/*.[ot]tf' -exec mv -f {} "${S}" \;
	fi
}
