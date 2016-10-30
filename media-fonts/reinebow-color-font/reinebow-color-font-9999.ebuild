# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xerographer/${PN}"
else
	inherit vcs-snapshot
	MY_PV="e7b6145"
	SRC_URI="
		mirror://githubcl/xerographer/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A SVG-in-OpenType Polychromatic Color Font"
HOMEPAGE="https://xerographer.github.io/${PN%%-*}"

LICENSE="CC-BY-4.0 MIT"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/scfbuild
"
FONT_S=( build )

src_prepare() {
	default
	sed -e '/webify/d' -i "${S}"/Makefile
}

src_compile() {
	emake \
		SCFBUILD="${EROOT}usr/bin/scfbuild"
}
