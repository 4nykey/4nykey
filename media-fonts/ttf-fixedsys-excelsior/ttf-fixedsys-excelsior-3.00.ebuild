# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator

MY_PV="$(delete_all_version_separators)"
DESCRIPTION="Fixedsys Excelsior Truetype Multilingual Font"
HOMEPAGE="http://www.fixedsysexcelsior.com"
SRC_URI="http://www.fixedsysexcelsior.com/fonts/FSEX${MY_PV}.ttf"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}"

src_unpack() {
	cp ${DISTDIR}/${A} .
}
