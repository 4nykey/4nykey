# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/source-pro/source-pro-20130316.ebuild,v 1.2 2013/10/21 12:18:39 grobian Exp $

EAPI=5

BASE_URI="https://codeload.github.com/adobe-fonts/"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	DEPEND="
		media-gfx/afdko
	"
	CHECKREQS_DISK_BUILD="$(usex cjk 1980 450)M"
else
	S="${WORKDIR}"
	MY_COD="source-code-pro/2.010R-ro/1.030R-it"
	MY_SER="source-serif-pro/1.017R"
	MY_SAN="source-sans-pro/2.010R-ro/1.065R-it"
	MY_CJK="source-han-sans/1.004R"
	SRC_URI="
		${BASE_URI}${MY_COD%%/*}/tar.gz/${MY_COD#*/} -> ${MY_COD//\//-}.tar.gz
		${BASE_URI}${MY_SER%%/*}/tar.gz/${MY_SER#*/} -> ${MY_SER//\//-}.tar.gz
		${BASE_URI}${MY_SAN%%/*}/tar.gz/${MY_SAN#*/} -> ${MY_SAN//\//-}.tar.gz
		cjk? ( ${BASE_URI}${MY_CJK%%/*}/tar.gz/${MY_CJK#*/} -> ${MY_CJK//\//-}.tar.gz )
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	use cjk && DOCS=${MY_CJK//\//-}/*.pdf
	CHECKREQS_DISK_BUILD="$(usex cjk 1940 40)M"
fi
inherit font check-reqs

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html"

LICENSE="OFL-1.1 cjk? ( Apache-2.0 )"
SLOT="0"
IUSE="cjk"

RDEPEND="app-eselect/eselect-fontconfig"

FONT_SUFFIX="otf ttf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		local x
		for x in {code,sans,serif}-pro $(usex cjk 'han-sans' ''); do
		EGIT_REPO_URI="${BASE_URI}source-${x}" \
		EGIT_CHECKOUT_DIR="${S}/source-${x}" \
			git-r3_src_unpack
		done
	else
		default
	fi
}

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		find \
			"${MY_COD//\//-}" \
			"${MY_SER//\//-}" \
			"${MY_SAN//\//-}" \
			$(usex cjk "${MY_CJK//\//-}/SubsetOTF" '') \
			-mindepth 2 -name '*.[ot]tf' -exec mv -f {} "${S}" \;
	elif use cjk; then
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
	[[ -n ${PV%%*9999} ]] && return 0

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
}

src_install() {
	font_src_install
	[[ -n ${PV%%*9999} ]] && dohtml */*.html
}
