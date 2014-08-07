# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="infinality-bundle-fonts base collection"
HOMEPAGE="http://bohoomil.com"
#https://github.com/bohoomil/fontconfig-ultimate/blob/pkgbuild/ibfonts-meta-base/PKGBUILD
SRC_URI=(
	otf-heuristica-ib-1.0.2-1
	ttf-dejavu-ib-2.34-9
	ttf-courier-prime-ib-1.203-4
	ttf-liberation-ib-2.00.1-6
	ttf-noto-sans-ib-2014.07-1
	ttf-noto-serif-ib-2014.07-1
	ttf-symbola-ib-7.12-3
)
SRC_URI=( ${SRC_URI[@]/#/http://bohoomil.com/repo/fonts/} )
SRC_URI="${SRC_URI[@]/%/-any.pkg.tar.xz}"
RESTRICT="primaryuri"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-fonts/heuristica
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/notofonts
	media-fonts/symbola
"
DEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	mv usr/share/fonts/ttf-courier-prime-ib/*.ttf .
	rm -rf etc/fonts/conf.d
}

src_install() {
	doins -r etc
	font_src_install
}
