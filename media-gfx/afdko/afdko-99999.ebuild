# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
	PATCHES=( "${FILESDIR}"/${PN}*.diff )
	LICENSE="Apache-2.0"
else
	SRC_URI="http://download.macromedia.com/pub/developer/opentype/FDK-${PV/.}-LINUX.zip"
	RESTRICT="primaryuri"
	S="${WORKDIR}"
	KEYWORDS="~amd64 ~x86"
	LICENSE="FDK"
	LICENSE_URL="http://www.adobe.com/devnet/opentype/afdko/eula.html"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-python/fonttools
"

src_prepare() {
	sed \
		-e 's:\(AFDKO_Python=\).*:\1"/usr/bin/env python2.7":' \
		-i FDK/Tools/linux/setFDKPaths
	base_src_prepare
}

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		tc-export CC
		local x
		find -path '*/linux/gcc/debug/Makefile' -printf '%h\n'|while read x; do
			emake XFLAGS="${CFLAGS}" -C "${x}" || die
		done
		find -path '*exe/linux/debug/*' -exec mv -fv {} "FDK/Tools/linux" \;
	else
		rm -rf "FDK/Tools/linux/Python"
	fi
}

src_install() {
	local FDK_EXE="/opt/${PN}/FDK/Tools/linux"
	if [[ ${PV} == *9999* ]]; then
		FDK_EXE="/usr/$(get_libdir)/${PN}/FDK/Tools/linux"
	fi
	printf \
		"export FDK_EXE=\"${FDK_EXE}\"\nexport PATH=\"\${FDK_EXE}:\${PATH}\"\n" \
		> "${T}"/${PN}
	insinto /etc
	doins "${T}"/${PN}

	insinto "${FDK_EXE%/*}"
	doins -r "${S}"/FDK/Tools/SharedData
	exeinto "${FDK_EXE}"
	doexe FDK/Tools/linux/*

	dodoc FDK/Technical\ Documentation/*.pdf
	dohtml FDK/Technical\ Documentation/*.htm*
}
