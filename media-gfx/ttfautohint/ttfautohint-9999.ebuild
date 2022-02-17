# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools qmake-utils
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://repo.or.cz/${PN}.git"
	MY_G="${P}/.gnulib"
else
	SRC_URI="
		https://download.savannah.gnu.org/releases/freetype/${P}.tar.gz
		mirror://sourceforge/freetype/${PN}/${PV}/${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for automated hinting of truetype fonts"
HOMEPAGE="https://www.freetype.org/ttfautohint/index.html"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0"
IUSE="qt5"

RDEPEND="
	media-libs/harfbuzz
	media-libs/freetype
	qt5? ( dev-qt/qtgui:5 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-apps/help2man
"

src_prepare() {
	default

	[[ -f configure ]] && return
	AUTORECONF=true \
	autotools_run_tool ./bootstrap --no-bootstrap-sync --no-git --skip-po \
		--force
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-doc
		$(use_with qt5 qt)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	emake ${PN}.1 $(usex qt5 ${PN}GUI.1 '') -C frontend
}

src_install() {
	default
	doman frontend/*.1
}
