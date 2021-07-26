# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=(
	aile
	curly
	custom
	+default
	etoile
	slab
	fixed
	ss01
	ss02
	ss03
	ss04
	ss05
	ss06
	ss07
	ss08
	ss09
	ss10
	ss11
	ss12
	ss13
	ss14
	ss15
	ss16
	ss17
	ss18
	term
)
MY_PN="${PN%-*}"
FONT_PN="${MY_PN}"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/be5invis/${MY_PN^}.git"
	EGIT_BRANCH="dev"
else
	MY_PV=$(ver_rs 3 '-' 4 '.')
	SRC_URI="
		mirror://githubcl/be5invis/${MY_PN^}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN^}-${MY_PV}"
fi
inherit savedconfig font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+autohint savedconfig"
REQUIRED_USE="
	?? ( ${MY_FONT_TYPES[@]/#+/} )
	|| ( ${MY_FONT_VARIANTS[@]/#+/} )
	font_variants_custom? ( savedconfig )
"
BDEPEND="
	net-libs/nodejs[npm]
	autohint? ( media-gfx/ttfautohint )
"
RDEPEND="
	!media-fonts/iosevka
	!media-fonts/iosevka-bin
"

pkg_pretend() {
	has network-sandbox ${FEATURES} && die "npm requires network access"
}

src_prepare() {
	default
	if use font_variants_custom; then
		local _p="private-build-plans.toml"
		local _m="
	Custom build requires ${_p} file in
	${PORTAGE_CONFIGROOT}etc/portage/savedconfig/${CATEGORY}/${PN}, see
	https://github.com/be5invis/Iosevka#configuring-custom-build"
		restore_config ${_p}
		if [[ -e "${S}"/${_p} ]]; then
			cat ${_p} >> build-plans.toml
		else
			die "${_m}"
		fi
	fi
	npm install || die
}

src_compile() {
	local -x MAKE="npm run build" MAKEOPTS="--verbose --"
	local _n="${MY_PN}" _s _v=() _t=()

	if use font_types_ttc; then

		FONT_S=( dist/.super-ttc )
		if use font_variants_default; then
			_t+=( ${_n} )
		fi
		_v=( ${FONT_VARIANTS[@]/default} )
		_v=( ${_v[@]/fixed} )
		_v=( ${_v[@]/term} )
		for _s in ${_v[@]}; do
			if use font_variants_${_s}; then
				_t+=( ${_n}-${_s} )
			fi
		done
		if use font_variants_slab && use font_variants_curly; then
			_t+=( ${_n}-curly-slab )
		fi
		emake "${_t[@]/#/super-ttc::}"

	else

		local _v="ttf$(usex autohint '' '-unhinted')"

		for _s in ${FONT_VARIANTS[@]}; do
				_s=${_s#default}
				_t+=( ${_n}-${_s} )
		done
		if use font_variants_slab; then
			use font_variants_fixed && _t+=( ${_n}-fixed-slab )
			use font_variants_term && _t+=( ${_n}-term-slab )
			if use font_variants_curly; then
				_t+=( ${_n}-curly-slab )
				use font_variants_fixed && _t+=( ${_n}-fixed-curly-slab )
				use font_variants_term && _t+=( ${_n}-term-curly-slab )
			fi
		fi
		if use font_variants_curly; then
			use font_variants_fixed && _t+=( ${_n}-fixed-curly )
			use font_variants_term && _t+=( ${_n}-term-curly )
		fi

		_t=( ${_t[@]/%-} )
		emake "${_t[@]/#/${_v}::}"

		FONT_S=( ${_t[@]/#/dist/} )
		FONT_S=( ${FONT_S[@]/%//${_v}} )
	fi
}
