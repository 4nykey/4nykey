# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CHECKREQS_DISK_BUILD="5835M"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="74f7c33"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit check-reqs multiprocessing font

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/fontmake
"
RDEPEND="!media-fonts/notofonts"

FONT_SUFFIX="otf"
DOCS="*.md"

src_prepare() {
	default
	sed \
		-e 's:fontmake:& -o otf:' \
		-i build.sh
}

src_compile() {
	local g
	multijob_init
	for g in src/*.glyphs src/*/*.plist; do
		multijob_pre_fork
		(
			multijob_child_init
			/bin/bash ./build.sh build_one "${g}" || \
			echo -n " ${g}" >> ${T}/_failed
		) &
	done
	multijob_finish
	find -type f -size 0 -delete
	find -name '*.otf' -exec mv -f {} "${S}" \;
	[[ -e ${T}/_failed ]] && \
		ewarn "These fonts failed to build:$(<${T}/_failed)"
}
