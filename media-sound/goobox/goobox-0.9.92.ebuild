# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="CD player and ripper for the Gnome2 desktop"
HOMEPAGE="http://www.gnomefiles.org/app.php?soft_id=531"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"
IUSE="oggvorbis mp3 flac doc"

RDEPEND=">=sys-libs/glibc-2
	>=x11-libs/gtk+-2.4
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/libbonoboui-2.6
	>=gnome-base/gnome-vfs-2.6
	>=gnome-base/libglade-2.4
	>=media-libs/gstreamer-0.8
	>=gnome-extra/gnome-media-2.8
	media-plugins/gst-plugins-cdparanoia
	oggvorbis? (media-plugins/gst-plugins-vorbis)
	mp3? (media-plugins/gst-plugins-lame)
	flac? (media-plugins/gst-plugins-flac)"


DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog COPYING INSTALL MAINTAINERS NEWS README TODO"

