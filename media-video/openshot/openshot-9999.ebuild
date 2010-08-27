# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND=2
PYTHON_USE_WITH=xml

inherit distutils fdo-mime python bzr

DESCRIPTION="OpenShot Video Editor is a non-linear video editor"
HOMEPAGE="http://www.openshotvideo.com"
EBZR_REPO_URI="lp:openshot/"
EBZR_PATCHES="${FILESDIR}"/${PN}*.diff

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/pygtk
	dev-python/pygoocanvas
	dev-python/pyxdg
	gnome-base/librsvg
	media-libs/mlt[python]
	media-sound/sox[encode]
	media-video/ffmpeg[encode]
"

src_install() {
	FAKEROOTKEY=1 distutils_src_install
	find openshot -type f -! -iregex '.*\.[pm][yo]' -! -path '*/locale/*'|\
		xargs tar -cf -|tar -xf - -C "${D}"/usr/share
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
