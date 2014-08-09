# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="infinality-bundle-fonts extended collection"
HOMEPAGE="http://bohoomil.com"
#https://github.com/bohoomil/fontconfig-ultimate/blob/pkgbuild/ibfonts-meta-extended-lt/PKGBUILD
#https://github.com/bohoomil/fontconfig-ultimate/blob/pkgbuild/ibfonts-meta-extended/PKGBUILD
SRC_URI=(
	otf-cantarell-ib-0.0.15-3
	otf-cantoraone-ib-1.001-4
	otf-oswald-ib-3.0-5
	otf-quintessential-ib-1.000-4
	t1-urw-fonts-ib-2.4-5
	ttf-caladea-ib-20130214-4
	ttf-carlito-ib-20130920-5
	ttf-droid-ib-20121017-9
	ttf-gelasio-ib-1.00-3
	ttf-liberastika-ib-1.1.4-1
	ttf-merriweather-ib-1.003-6
	ttf-merriweather-sans-ib-1.003-6
	ttf-noto-sans-multilang-ib-2014.07-2
	ttf-noto-serif-multilang-ib-2014.07-1
	ttf-opensans-ib-1.2-11
	ttf-signika-family-ib-1.0001-5
	ttf-ubuntu-font-family-ib-0.80-9
	ttf-ddc-uchen-ib-1.000-4
	ttf-faruma-ib-2.0-1
	ttf-lohit-odia-ib-2.5.5-4
	ttf-lohit-punjabi-ib-2.5.3-5
)
SRC_URI=( ${SRC_URI[@]/#/http://bohoomil.com/repo/fonts/} )
SRC_URI="${SRC_URI[@]/%/-any.pkg.tar.xz}"
RESTRICT="primaryuri"

LICENSE="Apache-2.0 OFL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-fonts/ibfonts-base
	media-fonts/cantarell
	media-fonts/source-pro
	media-fonts/font-xfree86-type1
	media-fonts/urw-fonts
	media-fonts/droid
	media-fonts/liberastika-ttf
	media-fonts/opensans
	media-fonts/ubuntu-font-family
"
DEPEND=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="otf ttf"

src_prepare() {
	rm -rf \
		usr/share/fonts/otf-cantarell-ib \
		usr/share/fonts/t1-cursor-ib \
		usr/share/fonts/t1-urw-fonts-ib \
		usr/share/fonts/ttf-droid-ib \
		usr/share/fonts/ttf-liberastika-ib \
		usr/share/fonts/ttf-noto* \
		usr/share/fonts/ttf-opensans-ib \
		usr/share/fonts/ttf-ubuntu-font-family-ib \
		etc/fonts/conf.d
	mv usr/share/fonts/*/*.[ot]tf .
}

src_install() {
	doins -r etc
	font_src_install
}
