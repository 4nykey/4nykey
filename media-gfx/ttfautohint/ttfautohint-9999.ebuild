# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools qmake-utils
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
	MY_G="${P}/.gnulib"
else
	inherit vcs-snapshot
	MY_G="gnulib-f88e6fc"
	MY_PV="7fa4bca"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		http://repo.or.cz/ttfautohint.git/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
		https://git.savannah.gnu.org/cgit/${MY_G%-*}.git/snapshot/${MY_G}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
SRC_URI+="
	doc? ( https://www.freetype.org/ttfautohint/doc/img/ttfautohintGUI.png )
"

DESCRIPTION="A library for automated hinting of truetype fonts"
HOMEPAGE="https://www.freetype.org/ttfautohint/index.html"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0"
IUSE="-doc qt4"

RDEPEND="
	media-libs/harfbuzz
	qt4? ( dev-qt/qtgui:4 )
"
DEPEND="
	${RDEPEND}
	sys-apps/help2man
	doc? (
		media-gfx/inkscape
		app-text/pandoc
		virtual/latex-base
		media-libs/fontconfig
		media-fonts/noto
		|| (
			media-fonts/noto-fonts-alpha
			media-fonts/noto-source
		)
		media-fonts/freefont
	)
"

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && sed \
		-e "s:m4_esyscmd.*VERSION]):${PV//_/-}:" -i configure.ac

	if use doc; then
	local \
	_n="$(fc-match -f %{file} $(awk -F= '/noto_font_file=/ {print $2}' configure.ac))" \
	_a="$(fc-match -f %{file} $(awk -F= '/noto_font_alpha_file=/ {print $2}' configure.ac))"
	sed \
		-e "s:\(noto_font_file=\).*:\1${_n}:" \
		-e "s:\(noto_font_alpha_file=\).*:\1${_a}:" \
		-i configure.ac
	cp "${DISTDIR}"/ttfautohintGUI.png "${S}"/doc/img/
	sed -e 's:\.ttf::' -i doc/template.tex
	fi

	AUTORECONF=true \
	autotools_run_tool ./bootstrap --no-bootstrap-sync --no-git --skip-po \
		--gnulib-srcdir="${WORKDIR}/${MY_G}" --force
	eautoreconf
}

src_configure() {
	local _q="$(qt4_get_bindir)" \
	myeconfargs=(
		$(use_with doc)
		$(use_with qt4 qt)
	)
	QMAKE="${_q}/qmake" MOC="${_q}/moc" UIC="${_q}/uic" RCC="${_q}/rcc" \
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	emake ${PN}.1 $(usex qt4 ${PN}GUI.1 '') -C frontend
}

src_install() {
	default
	doman frontend/*.1
	local _d="${ED}/usr/share/doc/${PF}"
	if [[ -f "${_d}"/${PN}.html ]]; then
		cd "${_d}"
		mkdir -p html
		mv -f *.{js,html} img html/
	fi
}
