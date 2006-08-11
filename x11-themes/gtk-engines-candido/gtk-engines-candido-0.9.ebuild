# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Candido is the Gtk2 cairo-based engine"
HOMEPAGE="http://candido.berlios.de/"
SRC_URI="http://download.berlios.de/candido/Candido-Engine.tar.bz2
	http://candido.berlios.de/media/download_gallery/Candido.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8"

S="${WORKDIR}/Candido-Engine"

pkg_setup() {
	if has_version '>=x11-libs/gtk+-2.10'; then
		GTK210=1
	fi
}

src_compile() {
	econf --enable-animation || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	insinto /usr/share/themes/
	cd "${WORKDIR}"
	for dir in Candido{,-Light}; do
		if [[ -n "GTK210" ]]; then
			find $dir -type f -name gtkrc | xargs sed -i '/GTK_SHADOW_NONE/d'
		fi
		cp -r $dir "${D}/usr/share/themes/"
	done
}
