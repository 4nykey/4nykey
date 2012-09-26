# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="cli gtk nls +plugins qt4 sdl vdpau xv"
REQUIRED_USE="|| ( cli gtk qt4 )"

RDEPEND="
	cli? ( ~media-video/avidemux-cli-${PV}:${SLOT}[nls=,vdpau=] )
	gtk? ( ~media-video/avidemux-gtk-${PV}:${SLOT}[nls=,sdl=,xv=] )
	qt4? ( ~media-video/avidemux-qt4-${PV}:${SLOT}[nls=,sdl=,vdpau=,xv=] )
	plugins? ( ~media-video/avidemux-plugins-${PV}:${SLOT}[cli=,gtk=,qt4=,vdpau=] )
"
DEPEND=""
