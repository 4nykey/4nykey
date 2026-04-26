# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-any-r1
if [[ ${PV} == *9999* ]]; then
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
	REQUIRED_USE="!binary"
else
	SRC_URI="
	binary? (
		ftp://ftp.dvo.ru/pub/Font/${PN}/${PN}-ttf-r${PV}.tar.xz
		mirror://gcarchive/${PN}/${PN}-ttf-r${PV}.tar.xz
	)
	!binary? (
		ftp://ftp.dvo.ru/pub/Font/${PN}/${PN}-src-r${PV}.tar.xz
	)
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font-r1

DESCRIPTION="A contrast sans-serif font based on the Teams font"
HOMEPAGE="https://code.google.com/p/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

RESTRICT="primaryuri"
BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
			media-gfx/xgridfit[${PYTHON_SINGLE_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]" &&
	python_has_version "media-gfx/xgridfit[${PYTHON_SINGLE_USEDEP}]"
}

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}
