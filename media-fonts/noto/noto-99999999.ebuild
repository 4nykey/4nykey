# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary cjk emoji pipeline"

DEPEND=""
RDEPEND="
	media-fonts/noto-fonts
	cjk? ( media-fonts/noto-cjk )
	emoji? ( media-fonts/noto-emoji )
	pipeline? (
		binary? ( media-fonts/noto-fonts-alpha )
		!binary? ( media-fonts/noto-source )
	)
"
