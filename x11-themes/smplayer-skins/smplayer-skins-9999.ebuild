# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	ESVN_REPO_URI="https://github.com/smplayer-dev/${PN}"
else
	MY_PV="a5345e6"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/smplayer-dev/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="https://www.smplayer.info"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
IUSE=""
BDEPEND="
	dev-qt/qtbase:6
"
RDEPEND="
	media-video/smplayer
"
DOCS=( Changelog.md README.txt )

src_prepare() {
	default
	sed \
		-e 's:usr/local:${EPREFIX}/usr:' \
		-e 's:install -d \$(THEMES_PATH):& $(THEMES_PATH)/../../doc/$(PF):' \
		-e '/README/s:/\([^/]\+\)/$:/../../doc/$(PF)/\1_README.txt:' \
		-i Makefile
	sed \
		-e "s:rcc -binary:$(qt6_get_libexecdir)/&:" \
		-i themes/Makefile
}
