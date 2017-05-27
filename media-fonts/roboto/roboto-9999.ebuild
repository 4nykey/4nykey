# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python2_7 )
inherit vcs-snapshot
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	REQUIRED_USE="!binary"
else
	SRC_URI="
		binary? (
			https://github.com/google/${PN}/releases/download/v${PV}/${PN}-hinted.zip
			-> ${P}.zip
		)
		!binary? (
			mirror://githubcl/google/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_D=(
	typesupply/feaTools-8fc73f8
	robofab-developers/robofab-62229c4
	googlei18n/ufo2ft-6184b14
)
SRC_URI+="
!binary? ( $(for _d in ${MY_D[@]}; do
	printf 'mirror://githubcl/%s/tar.gz/%s -> %s.tar.gz ' \
		${_d%-*} ${_d##*-} ${_d#*/}
done) )
"
RESTRICT="primaryuri"

DESCRIPTION="Google's signature family of fonts"
HOMEPAGE="https://github.com/google/roboto"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+binary test"
REQUIRED_USE="
	binary? ( !font_types_otf )
	test? ( font_types_ttf )
"

DEPEND="
	binary? (
		app-arch/unzip
	)
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/booleanOperations[${PYTHON_USEDEP}]
			dev-python/cython[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			sci-libs/scipy[${PYTHON_USEDEP}]
			dev-python/compreffor[${PYTHON_USEDEP}]
			dev-python/cu2qu[${PYTHON_USEDEP}]
			dev-python/nototools[${PYTHON_USEDEP}]
			dev-python/ufoLib[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}/${MY_PN}"
	else
		python-any-r1_pkg_setup
		FONT_S=( out/Roboto{,Condensed}{O,T}TF )
	fi
	font-r1_pkg_setup
}

src_unpack() {
	[[ ${PV} == *9999* ]] && git-r3_src_unpack
	vcs-snapshot_src_unpack
	MY_D=( ${MY_D[@]/*\//${WORKDIR}/} )
	MY_D=( ${MY_D[@]/%//Lib/*} )
	mv -f ${MY_D[@]} "${S}"/scripts/lib/
}

src_prepare() {
	default
	use binary && return
	use font_types_otf || \
		sed -e 's:\(proj\.buildOTF =\).*:\1False:' -i scripts/build-v2.py
	use font_types_ttf || \
		sed -e '/proj\.generateTTFs()/d' -i scripts/build-v2.py
	sed -e "s:\<2016\>:$(date +%Y):" -i scripts/run_general_tests.py
}

src_compile() {
	use binary && return
	default
}

src_test() {
	use binary && return
	local -x PYTHONPATH="${PYTHONPATH}:${S}/scripts/lib"
	emake test-coverage test-general
}
