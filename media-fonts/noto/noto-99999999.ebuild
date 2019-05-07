# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary cjk emoji"

DEPEND=""
RDEPEND="
	binary? ( media-fonts/noto-fonts )
	!binary? ( media-fonts/noto-source )
	cjk? ( media-fonts/noto-cjk )
	emoji? ( media-fonts/noto-emoji )
"
