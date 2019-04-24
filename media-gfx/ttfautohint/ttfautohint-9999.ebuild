# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools qmake-utils
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://repo.or.cz/${PN}.git"
	MY_G="${P}/.gnulib"
else
	inherit vcs-snapshot
	MY_G="gnulib-91584ed"
	MY_PV="7fa4bca"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		https://repo.or.cz/ttfautohint.git/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
		https://git.savannah.gnu.org/cgit/${MY_G%-*}.git/snapshot/${MY_G}.tar.gz
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
	sys-apps/help2man
"

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && sed \
		-e "s:m4_esyscmd.*VERSION]):${PV//_/-}:" -i configure.ac

	AUTORECONF=true \
	autotools_run_tool ./bootstrap --no-bootstrap-sync --no-git --skip-po \
		--gnulib-srcdir="${WORKDIR}/${MY_G}" --force
	eautoreconf
}

src_configure() {
	local _q="$(qt5_get_bindir)" \
	myeconfargs=(
		--without-doc
		$(use_with qt5 qt)
	)
	QMAKE="${_q}/qmake" MOC="${_q}/moc" UIC="${_q}/uic" RCC="${_q}/rcc" \
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
