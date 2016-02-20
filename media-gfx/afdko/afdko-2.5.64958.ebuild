# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit base python-r1
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
	LICENSE="Apache-2.0"
	S="${WORKDIR}/${P}/FDK"
	FDK_EXE="/usr/$(get_libdir)/${PN}/FDK/Tools/linux"
else
	inherit unpacker versionator
	MY_P=$(version_format_string 'FDK-$1$2-LINUX.b$3')
	SRC_URI="
		http://download.macromedia.com/pub/developer/opentype/FDK.${PV}/${MY_P}.zip
		https://github.com/adobe-type-tools/afdko/releases/download/${PV}/${MY_P}.zip
	"
	RESTRICT="primaryuri"
	DEPEND="$(unpacker_src_uri_depends)"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~x86"
	LICENSE="FDK"
	LICENSE_URL="http://www.adobe.com/devnet/opentype/afdko/eula.html"
	FDK_EXE="/opt/${PN}/FDK/Tools/linux"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/fonttools-2.5
"
PATCHES=( "${FILESDIR}"/${PN}*.diff )

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		tc-export CC
		local x
		find -path '*/linux/gcc/debug/Makefile' -printf '%h\n'|while read x; do
			emake XFLAGS="${CFLAGS}" -C "${x}" || die
		done
		find -path '*exe/linux/debug/*' -exec mv -fv {} "FDK/Tools/linux" \;
	else
		rm -rf "Tools/linux/Python"
	fi
}

src_install() {
	printf \
		"export FDK_EXE=\"${FDK_EXE}\"\nexport PATH=\"\${FDK_EXE}:\${PATH}\"\n" \
		> "${T}"/${PN}
	insinto /etc
	doins "${T}"/${PN}

	insinto "${FDK_EXE%/*}"
	doins -r "${S}"/Tools/SharedData
	exeinto "${FDK_EXE}"
	doexe Tools/linux/*

	dodoc Technical\ Documentation/*.pdf
	dohtml Technical\ Documentation/*.htm*
}
