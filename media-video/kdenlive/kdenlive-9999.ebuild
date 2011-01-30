# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kdenlive/kdenlive-0.7.7.1.ebuild,v 1.4 2010/07/07 12:28:51 fauli Exp $

EAPI=3
KDE_LINGUAS="
ca cs da de el es fi fr gl he hr hu it nl pl pt pt_BR ru sl tr uk zh
"
PREFIX="/usr"
inherit kde4-base subversion

DESCRIPTION="Kdenlive! (pronounced Kay-den-live) is a Non Linear Video Editing Suite for KDE."
HOMEPAGE="http://www.kdenlive.org/"
ESVN_REPO_URI="https://kdenlive.svn.sourceforge.net/svnroot/kdenlive/trunk/kdenlive"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug semantic-desktop"

DEPEND="
	>=media-libs/mlt-0.5.10[ffmpeg,sdl,xml,melt,qt4,kde]
	media-video/ffmpeg[X,sdl]
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop?]
	dev-libs/qjson
	!${CATEGORY}/${PN}:0
"

DOCS="AUTHORS README"

pkg_setup() {
	mycmakeargs+=(
		$(cmake-utils_use_with semantic-desktop Nepomuk)
	)
}
