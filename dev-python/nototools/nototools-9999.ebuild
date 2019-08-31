# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="39ff50d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV//./-}-tooling-for-phase3-update"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlei18n/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.36[ufo,${PYTHON_USEDEP}]
	>=dev-python/pillow-4[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/freetype-py[${PYTHON_USEDEP}]
	media-libs/harfbuzz
"
RDEPEND="
	${DEPEND}
	media-gfx/scour
	app-i18n/unicode-cldr
	app-i18n/unicode-data
	app-i18n/unicode-emoji
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-stringio.diff
	)

	local _f _s
	for _f in nototools/[a-z]*.py; do basename "${_f}" '.py'; done | \
		while read _s; do
			grep -rl "^import ${_s}" | xargs --no-run-if-empty \
				sed -i -e "s:^import ${_s}:from nototools &:"
		done

	sed -e "/packages=/s: + \['third_party'\]::" -i setup.py
	sed -e 's: \(ufoLib\.pointPen\): fontTools.\1:' \
		-i nototools/shape_diff.py
	sed -e "s:HB_SHAPE_PATH,:'/usr/bin/hb-shape',:" \
		-i nototools/render.py
	sed \
		-e "/_DATA_DIR_PATH =/s:=.*:= '${EROOT}/usr/share/unicode-data':" \
		-e '/third_party.*\<ucd\>/d' \
		-e "s:'\(emoji-[a-z-]\+\.txt'\):'../unicode/emoji/\1:g" \
		-i nototools/unicode_data.py
	grep -rl CLDR_DIR nototools | xargs sed -i \
		-e "/CLDR_DIR =/s:=.*:= '${EROOT}/usr/share/unicode/cldr':"
	distutils-r1_python_prepare_all
}

python_test() {
	local -x \
		PYTHONPATH="${BUILD_DIR}/lib/nototools:${PYTHONPATH}"
	pytest -v tests || die
}
