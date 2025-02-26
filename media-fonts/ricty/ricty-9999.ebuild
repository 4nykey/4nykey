# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_IN="Inconsolata-LGC-8adfef7" #20160404 https://github.com/MihailJP/Inconsolata-LGC
MY_MI="migu-1m-20200307"        #20150712 https://osdn.net/pkg/mix-mplus-ipa/migu
MY_MP="mplus-TESTFLIGHT-063a"    #20171025 https://osdn.net/rel/mplus-fonts/TESTFLIGHT
S="${WORKDIR}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3 cvs
	EGIT_REPO_URI="https://github.com/rictyfonts/rictyfonts.github.io.git"
	ECVS_USER="anonymous"
	ECVS_MODULE="mixfont-mplus-ipa"
	ECVS_SERVER="cvs.osdn.jp:/cvsroot/mix-mplus-ipa"
	SRC_URI="https://osdn.net/dl/mplus-fonts/${MY_MP}.tar.xz"
else
	SRC_URI="
		mirror://githubraw/rictyfonts/rictyfonts.github.io/11f3cc6/files/${PN}_generator-${PV}.sh
		mirror://githubcl/MihailJP/${MY_IN%-*}/tar.gz/${MY_IN##*-}
		-> ${MY_IN}.tar.gz
		https://jaist.dl.osdn.jp/mix-mplus-ipa/72511/${MY_MI}.zip
		https://osdn.net/dl/mix-mplus-ipa/${MY_MI}.zip
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1
RESTRICT="primaryuri bindist"

DESCRIPTION="A monotype font combining Inconsolata and Migu 1M"
HOMEPAGE="https://rictyfonts.github.io"

LICENSE="OFL-1.1 IPAfont"
SLOT="0"
IUSE=""

BDEPEND="
	media-gfx/fontforge
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		EGIT_REPO_URI="https://github.com/MihailJP/Inconsolata-LGC.git" \
		EGIT_CHECKOUT_DIR="${S}/${MY_IN}" git-r3_src_unpack
		unpack ${MY_MP}.tar.xz
		ln -s "${WORKDIR}"/${P}/files/${PN}_generator.sh "${S}"/${PN}_generator.sh
		cvs_src_unpack
	else
		cp "${DISTDIR}"/${PN}_generator-${PV}.sh "${S}"/${PN}_generator.sh
		unpack ${MY_IN}.tar.gz ${MY_MI}.zip
	fi
}

src_prepare() {
	default
	if [[ -z ${PV%%*9999} ]]; then
		mv -f ${ECVS_MODULE}/mplus_outline_fonts/mig.d .
		xz -d mig.d/sfd.d/IPAGothic-*.sfd.xz
		sed \
			-e "/fontfile_mplus = /s:\['.*'\]:['mplus-1m-regular.ttf', 'mplus-1m-bold.ttf']:" \
			-i mig.d/migmix.py
		sed \
			-e 's:circle-mplus-:mplus-:' \
			-e "s:work\.d/:${MY_MP}/:" \
			-i mig.d/scripts/migu.py
		mkdir -p ${MY_MI}
	fi
	sed \
		-e 's:\<65542\>:65543:' \
		-e 's:\<65544\>:65545:' \
		-i "${S}"/ricty_generator.sh
}

src_compile() {
	if [[ -z ${PV%%*9999} ]]; then
		ebegin "Building Migu 1M regular"
		fontforge -script mig.d/scripts/migu.py 1M regular -quiet
		eend $? || die
		ebegin "Building Migu 1M bold"
		fontforge -script mig.d/scripts/migu.py 1M bold -quiet
		eend $? || die
		mv migu-1m-*.ttf ${MY_MI}
	fi

	ebegin "Building ${PN^}"
	sh ./${PN}_generator.sh -a \
		${MY_IN}/Inconsolata-LGC{,-Bold}.sfd \
		${MY_MI}/migu-1m-{regular,bold}.ttf
	eend $? || die
}
