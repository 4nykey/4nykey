# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}.git"
	DEPEND="media-gfx/afdko"
	CHECKREQS_DISK_BUILD="1530M"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}R
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	DOCS=${S}/*.pdf
	CHECKREQS_DISK_BUILD="1900M"
fi
inherit font check-reqs

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	app-eselect/eselect-fontconfig
"

FONT_SUFFIX="otf"

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		find SubsetOTF -mindepth 2 -name '*.otf' -exec mv -f {} "${S}" \;
	else
		cp "${FILESDIR}"/build.sh "${S}"
		sed \
			-e '/^makeotf/!d;/\<OTC\>/d' \
			-e 's:makeotf.*:& 2> "${T}"/${PN}.log || die "failed to build, see ${T}/${PN}.log":' \
			"${S}"/COMMANDS.txt > "${S}"/cmd.sh
	fi
}

src_compile() {
	[[ -z ${PV%%*9999} ]] && source "${S}"/build.sh
}
