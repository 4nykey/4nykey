# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="Open Sans is a clean and modern sans-serif typeface"
HOMEPAGE="http://opensans.com/"
SRC_URI="
http://www.google.com/fonts/download?kit=3hvsV99qyKCBS55e5pvb3k_UpNCUsIj1Q-eLvtScfRfjeAZG0syLSF0MtprGrcoF -> ${P}.zip
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	mv Open_Sans*/*.ttf .
}
