# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2

MY_PV="${PV%.*}~ppa1~natty${PV##*.}"
DESCRIPTION="AwOken - Awesome Token icon set"
HOMEPAGE="http://alecive.deviantart.com/art/AwOken-163570862"
SRC_URI="http://ppa.launchpad.net/alecive/antigone/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
RESTRICT="primaryuri"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk imagemagick"

DEPEND=""
RDEPEND="
	${DEPEND}
	gtk? ( gnome-extra/zenity )
	imagemagick? ( media-gfx/imagemagick )
"

src_prepare() {
	sed -i AwOken/awoken-icon-theme-customization \
		-e "s:\$DIR/\$ICNST\(/.*\.pdf\):/usr/share/doc/${PF}\1:"
	find -L -type l | xargs rm -f
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/icons
	doins -r AwOken{,Dark,White}
	dodoc debian/changelog debian/copyright
	mv "${D}"/usr/share/{icons/AwOken,doc/${PF}}/Installation_and_Instructions.pdf
	fperms +x /usr/share/icons/AwOken*/${PN}-customization*
	dosym /usr/{share/icons/AwOken,bin}/${PN}-customization
	newicon AwOken/clear/128x128/start-here/start-here-awoken.png ${PN}.png
	make_desktop_entry ${PN}-customization "AwOken Customization" ${PN}
}
