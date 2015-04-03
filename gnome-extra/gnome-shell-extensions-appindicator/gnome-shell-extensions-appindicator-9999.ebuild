# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 git-r3

DESCRIPTION="Adds AppIndicator support to gnome shell"
HOMEPAGE="https://github.com/rgcjonas/gnome-shell-extension-appindicator"
SRC_URI=""
EGIT_REPO_URI="https://github.com/rgcjonas/gnome-shell-extension-appindicator.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_prepare() { :; }

src_configure() { :; }

src_compile() {
	emake config.js $(usex nls mo '')
}

src_install() {
	insinto /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
	doins -r interfaces-xml *.js{,on}
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.gschema.xml
	dodoc README.md
	insinto /usr/share
	use nls && doins -r locale
}

pkg_postinst() {
	gnome2_pkg_postinst

	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, to enable/disable extensions on a per-user basis,"
	elog "you can use the https://extensions.gnome.org/ web interface, the"
	elog "gnome-extra/gnome-tweak-tool GUI, or modify the org.gnome.shell"
	elog "enabled-extensions gsettings key from the command line or a script."
	elog
}
