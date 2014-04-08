# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils fdo-mime autotools-utils git-r3

DESCRIPTION="ClipIt is a lightweight, fully featured GTK+ clipboard manager"
HOMEPAGE="http://clipit.rspwn.com/"
EGIT_REPO_URI="git://git.code.sf.net/p/gtkclipit/code"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana nls"

RDEPEND="
	ayatana? ( dev-libs/libappindicator:2 )
	x11-libs/gtk+:2
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"
AUTOTOOLS_AUTORECONF="1"

src_configure() {
	local myeconfargs=(
		$(use_enable ayatana appindicator)
		$(use_enable nls)
	)
	PKG_CONFIG=`type -P pkg-config` \
	autotools-utils_src_configure
}

gnome2_pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
