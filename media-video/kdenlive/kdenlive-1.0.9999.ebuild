# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kdenlive/kdenlive-0.9.6.ebuild,v 1.3 2013/06/03 12:07:20 kensington Exp $

EAPI=5
KDE_LINGUAS="
ca cs da de el es et fi fr ga gl he hr hu it ja lt nb nds nl pl pt pt_BR ru sk
sl sv tr uk zh zh_CN zh_TW
"
KDE_HANDBOOK="optional"
OPENGL_REQUIRED="always"
inherit kde4-base git-2

DESCRIPTION="A non-linear video editing suite for KDE"
HOMEPAGE="http://www.kdenlive.org/"
EGIT_REPO_URI="git://anongit.kde.org/kdenlive"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="" #~amd64 ~x86"
IUSE="debug semantic-desktop"

RDEPEND="
	dev-libs/qjson
	media-libs/mlt[ffmpeg,sdl,xml,melt,qt4,kdenlive]
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
