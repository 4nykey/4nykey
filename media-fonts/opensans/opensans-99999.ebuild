# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font check-reqs mercurial

DESCRIPTION="Open Sans is a clean and modern sans-serif typeface"
HOMEPAGE="http://opensans.com/"
# hg repo is 3GB+ in size
CHECKREQS_DISK_BUILD="4G"
EHG_PROJECT="googlefontdirectory"
EHG_REPO_URI="https://code.google.com/p/${EHG_PROJECT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_S="${S}"
FONT_SUFFIX="ttf"

src_prepare() {
	mv apache/${PN}*/*.ttf .
}
