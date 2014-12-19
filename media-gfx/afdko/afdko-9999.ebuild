# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base git-r3

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"
EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-python/fonttools
"

src_prepare() {
	rm -f FDK/Tools/linux/{setFDKPaths,ttx}
	sed \
		-e '/\(env bash\|targetScript\)/!d' \
		-e 's:/usr/bin/env bash:/bin/sh:' \
		-e 's:\$[{]*AFDKO_Python[}]*:/usr/bin/env python:' \
		-e "s:\$[{]*AFDKO_Scripts[}]*:/usr/share/${PN}/SharedData/FDKScripts:" \
		-i FDK/Tools/linux/*
}

src_compile() {
	tc-export CC
	local x
	find -path '*/linux/gcc/release/Makefile' -printf '%h\n'|while read x; do
		emake XFLAGS="${CFLAGS}" -C "${x}" || die
	done
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${S}"/FDK/Tools/SharedData
	dobin FDK/Tools/linux/*
	find -path '*exe/linux/release/*' | xargs dobin
}
