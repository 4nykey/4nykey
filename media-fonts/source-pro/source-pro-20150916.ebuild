# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/source-pro/source-pro-20130316.ebuild,v 1.2 2013/10/21 12:18:39 grobian Exp $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	DEPEND="media-gfx/afdko"
else
	S="${WORKDIR}"
	MY_COD="source-code-pro/2.010R-ro/1.030R-it"
	MY_SER="source-serif-pro/1.017R"
	MY_SAN="source-sans-pro/2.020R-ro/1.075R-it"
	SRC_URI="
		mirror://github/adobe-fonts/${MY_COD%%/*}/archive/${MY_COD#*/}.tar.gz
		-> ${MY_COD//\//-}.tar.gz
		mirror://github/adobe-fonts/${MY_SER%%/*}/archive/${MY_SER#*/}.tar.gz
		-> ${MY_SER//\//-}.tar.gz
		mirror://github/adobe-fonts/${MY_SAN%%/*}/archive/${MY_SAN#*/}.tar.gz
		-> ${MY_SAN//\//-}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="
	http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html
"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="cjk"

RDEPEND="
	app-eselect/eselect-fontconfig
	cjk? ( media-fonts/source-han-sans )
"

FONT_SUFFIX="otf ttf"
FONT_CONF=( "${FILESDIR}"/63-${PN}.conf )

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		local x
		for x in {code,sans,serif}-pro; do
		EGIT_REPO_URI="https://github.com/adobe-fonts/source-${x}" \
		EGIT_CHECKOUT_DIR="${S}/source-${x}" \
			git-r3_src_unpack
		done
	else
		default
	fi
}

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		find "${MY_COD//\//-}" "${MY_SER//\//-}" "${MY_SAN//\//-}" \
			-mindepth 2 -name '*.[ot]tf' -exec mv -f {} "${S}" \;
	else
		sed \
			-e 's:makeotf.*:& 2> "${T}"/${_l}.log || die "error building ${_l}, see ${T}/${_l}.log":' \
			-e 's:addSVG=.*:addSVG=$(find "${S}" -name addSVGtable.py):' \
			-i "${S}"/*/build.sh
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
			source ./${x##*/}
		eend "$?"
	done
	
	find "${S}" -path '*/target/[OT]TF/*.[ot]tf' -exec mv -f {} "${S}" \;
}

src_install() {
	font_src_install
	[[ -n ${PV%%*9999} ]] && dohtml */*.html
}
