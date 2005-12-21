# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quodlibet/quodlibet-0.4.ebuild,v 1.2 2004/12/19 06:41:24 eradicator Exp $

inherit subversion

DESCRIPTION="Quod Libet is a GTK+-based audio player written in Python"
HOMEPAGE="http://www.sacredchao.net/quodlibet"
ESVN_REPO_URI="http://svn.sacredchao.net/svn/quodlibet/trunk/quodlibet"
ESVN_PATCHES="makefile.patch"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="mad vorbis flac musepack gnome wavpack modplug network"

DEPEND=">=virtual/python-2.3
	>=dev-python/pygtk-2.6
	>=dev-python/gst-python-0.8.2
	gnome? ( dev-python/gnome-python-extras )
	network? ( media-plugins/gst-plugins-gnomevfs )
	flac? ( dev-python/pyflac )
	vorbis? ( dev-python/pyvorbis )
	mad? ( dev-python/pymad
		dev-python/pyid3lib )
	musepack? ( media-libs/libmpcdec dev-python/ctypes )
	wavpack? ( media-sound/wavpack dev-python/ctypes )
	modplug? ( media-libs/libmodplug dev-python/ctypes )"

src_install() {
	make DESTDIR=${D} install || die
	dodoc TODO README NEWS
}
