# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
MY_INC="c6c7e43"
SRC_URI="
	!binary? (
		mirror://githubraw/google/fonts/${MY_INC}/ofl/inconsolata/Inconsolata-Regular.ttf
		mirror://githubraw/google/fonts/${MY_INC}/ofl/inconsolata/Inconsolata-Bold.ttf
		http://www.rs.tus.ac.jp/yyusa/${PN}/regular2oblique_converter.pe
	)
"
if [[ -z ${PV%%*9999} ]]; then
	inherit cvs git-r3
	EGIT_REPO_URI="https://github.com/seinto1003/${PN}.git"
	ECVS_USER="anonymous"
	REQUIRED_USE="!binary"
	DEPEND="
		app-arch/xz-utils
		dev-lang/perl
	"
	MY_MP="mplus-TESTFLIGHT-061"
	SRC_URI+="
		https://osdn.jp/dl/mplus-fonts/${MY_MP}.tar.xz
	"
else
	MY_MIGU="migu-1m-20150712"
	MY_MIGM="migmix-1m-20150712"
	SRC_URI+="
		binary? (
			http://www.rs.tus.ac.jp/yyusa/${PN}_diminished/${PN}_diminished-${PV}.tar.gz
		)
		!binary? (
			http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_generator-${PV}.sh
			http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_discord_converter.pe
			!migmix? ( https://osdn.jp/dl/mix-mplus-ipa/${MY_MIGU}.zip )
			migmix? ( https://osdn.jp/dl/mix-mplus-ipa/${MY_MIGM}.zip )
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	DEPEND="!binary? ( app-arch/unzip )"
fi
inherit python-any-r1 font

DESCRIPTION="A monotype Japanese font generated from Inconsolata and Migu 1M"
HOMEPAGE="http://www.rs.tus.ac.jp/yyusa/ricty.html"

LICENSE="BSD-2 OFL-1.1 IPAfont"
SLOT="0"
IUSE="+binary bindist migmix"
REQUIRED_USE+=" bindist? ( binary )"

DEPEND+="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""

FONT_SUFFIX="ttf"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		ECVS_MODULE="mixfont-mplus-ipa" \
		ECVS_SERVER="cvs.osdn.jp:/cvsroot/mix-mplus-ipa" \
			cvs_src_unpack
		unpack ${MY_MP}.tar.xz
	else
		mkdir -p "${S}"
		if use binary; then
			unpack ${PN}_diminished-${PV}.tar.gz
			mv "${WORKDIR}"/*.ttf "${FONT_S}"/
		else
			MY_MP="$(usex migmix ${MY_MIGM} ${MY_MIGU})"
			unpack ${MY_MP}.zip
		fi
	fi
}

src_prepare() {
	default
	if [[ -z ${PV%%*9999} ]]; then
		rm -f "${S}"/migu-1m-*.ttf
		cd "${WORKDIR}"/${MY_MP}
		mv -f "${WORKDIR}"/mixfont-mplus-ipa/mplus_outline_fonts/mig.d .
		xz -d mig.d/sfd.d/*.xz
		sed \
			-e "/fontfile_mplus = /s:\['.*'\]:['mplus-1m-regular.ttf', 'mplus-1m-bold.ttf']:" \
			-i mig.d/migmix.py
		sed \
			-e 's:circle-mplus-:mplus-:' \
			-i mig.d/scripts/migu.py
	else
		cp "${DISTDIR}"/${PN}_generator-${PV}.sh "${S}"/${PN}_generator.sh
	fi
}

src_compile() {
	use binary && return

	if [[ -z ${PV%%*9999} ]]; then
		pushd "${MY_MP}" > /dev/null
		if use migmix; then
			fontforge -script mig.d/migmix.py . mig.d/sfd.d || die
		else
			fontforge -script mig.d/scripts/migu.py 1M regular || die
			fontforge -script mig.d/scripts/migu.py 1M bold || die
		fi
		popd > /dev/null
	fi
	sh "${S}"/${PN}_generator.sh \
		"${DISTDIR}"/Inconsolata-{Regular,Bold}.ttf \
		"${WORKDIR}"/${MY_MP}/$(usex migmix migmix migu)-1m-{regular,bold}.ttf \
		|| die
	fontforge -lang=ff \
		-script "${DISTDIR}"/regular2oblique_converter.pe \
		"${S}"/*.ttf || die
}
