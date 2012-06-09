# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kdenlive/kdenlive-0.9.2.ebuild,v 1.1 2012/05/31 11:08:21 scarabeus Exp $

EAPI=4
KDE_LINGUAS="
ca cs da de el es et fi fr ga gl he hr hu it ja lt nb nds nl pl pt pt_BR ru sk
sl sv tr uk zh zh_CN zh_TW
"
KDE_HANDBOOK="optional"
OPENGL_REQUIRED="always"
inherit kde4-base git-2

DESCRIPTION="Kdenlive! (pronounced Kay-den-live) is a Non Linear Video Editing Suite for KDE."
HOMEPAGE="http://www.kdenlive.org/"
EGIT_REPO_URI="git://anongit.kde.org/kdenlive"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug semantic-desktop"

RDEPEND="
	dev-libs/qjson
	>=media-libs/mlt-0.7.8[ffmpeg,sdl,xml,melt,qt4,kde]
	virtual/ffmpeg[encode,sdl,X]
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
"
DEPEND="
	${RDEPEND}
"

DOCS=( AUTHORS ChangeLog README TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with semantic-desktop Nepomuk)
	)

	kde4-base_src_configure
}
