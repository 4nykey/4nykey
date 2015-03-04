# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PLOCALES="
ar bg ca cs da de el en_AU es eu fi fr gl he hr hu id is it ja lt ms nb nl pl
pms pt_BR pt ro ru si sq sr sv th tr uk vi zh_CN zh_TW
"
inherit gnome2 l10n python-single-r1

if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="http://sopcast-player.googlecode.com/svn/trunk"
	SRC_URI=""
else
	SRC_URI="http://sopcast-player.googlecode.com/files/${P}.tar.gz"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SopCast Player is a Linux GUI front-end for the SopCast p2p streaming"
HOMEPAGE="http://code.google.com/p/sopcast-player/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygtk:2
	net-p2p/sopcast
	media-video/vlc
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

rmpo() {
	rm -f "${S}"/po/${1}.po
}

src_prepare() {
	sed \
		-e '/build:/s:byte-compile::' \
		-i Makefile
	l10n_for_each_disabled_locale_do rmpo
	default
}

src_configure() {
	default
}

src_install() {
	default
	python_optimize "${D}"usr/share/${PN}/lib
}
