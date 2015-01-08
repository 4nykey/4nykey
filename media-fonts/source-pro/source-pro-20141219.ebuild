# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/source-pro/source-pro-20130316.ebuild,v 1.2 2013/10/21 12:18:39 grobian Exp $

EAPI=5

inherit base
if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	DEPEND="
		media-gfx/afdko
	"
else
	S="${WORKDIR}"
	inherit font
	CODE_PN="source-code-pro"
	CODE_PV="1.017R"
	SERI_PN="source-serif-pro"
	SERI_PV="1.017R"
	SANS_PN="source-sans-pro"
	SANS_PV="2.010R-ro/1.065R-it"
	CJK_PN="source-han-sans"
	CJK_PV="1.001R"
	SRC_URI="
		https://codeload.github.com/adobe-fonts/${CODE_PN}/tar.gz/${CODE_PV} -> ${CODE_PN}-${CODE_PV}.tar.gz
		https://codeload.github.com/adobe-fonts/${SERI_PN}/tar.gz/${SERI_PV} -> ${SERI_PN}-${SERI_PV}.tar.gz
		https://codeload.github.com/adobe-fonts/${SANS_PN}/tar.gz/${SANS_PV} -> ${SANS_PN}-${SANS_PV/\//-}.tar.gz
		cjk? ( https://codeload.github.com/adobe-fonts/${CJK_PN}/tar.gz/${CJK_PV} -> ${CJK_PN}-${CJK_PV}.tar.gz )
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	use cjk && DOCS=${CJK_PN}-${CJK_PV}/*.pdf
fi

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html"

LICENSE="OFL-1.1 cjk? ( Apache-2.0 )"
SLOT="0"
IUSE="cjk"

RDEPEND="app-admin/eselect-fontconfig"

FONT_SUFFIX="otf ttf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )

src_unpack() {
	local x
	if [[ ${PV} == *9999* ]]; then
		for x in {code,sans,serif}-pro $(usex cjk 'han-sans' ''); do
		EGIT_REPO_URI="https://github.com/adobe-fonts/source-${x}" \
		EGIT_CHECKOUT_DIR="${S}/source-${x}" \
			git-r3_src_unpack
		done
	else
		default
	fi

}

src_prepare() {
	if [[ ${PV} == *9999* ]] && use cjk; then
		cd "${S}"/source-han-sans
		mkdir -p target/OTF
		cat << EOF > build.sh
for x in $(find -mindepth 1 -maxdepth 1 -type d -name '[A-Z]*' -printf '"%f" '); do
pushd \${x}
$(grep makeotf COMMANDS.txt |grep -v OTC)
mv -f *.otf ../target/OTF/
popd
done
EOF
	fi
}

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		source /etc/afdko

		local x _d _l
		for x in "${S}"/*/build.sh; do
			_d="${x%/*}"
			_l="${_d##*/}"
			cd "${_d}"
			ebegin "Building ${_l}"
				sh ./${x##*/} >& "${T}"/${_l}.log
			eend "$?" || die "failed to build ${_l}, see ${T}/${_l}.log"
		done
		
		find "${S}" -path '*/target/[OT]TF/*.[ot]tf' -exec mv -f {} "${S}" \;
	else
		find \
			"${CODE_PN}-${CODE_PV}" \
			"${SERI_PN}-${SERI_PV}" \
			"${SANS_PN}-${SANS_PV/\//-}" \
			$(usex cjk "${CJK_PN}-${CJK_PV}/SubsetOTF" '') \
			-mindepth 2 -name '*.[ot]tf' -exec mv -f {} "${S}" \;
	fi
}

src_install() {
	font_src_install
	dohtml */*.html
}
