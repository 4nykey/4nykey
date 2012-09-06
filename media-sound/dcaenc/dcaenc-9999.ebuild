# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils git-2

DESCRIPTION="dcaenc is a encoder for the DTS Coherent Acoustics audio format"
HOMEPAGE="http://aepatrakov.narod.ru/dcaenc/"
EGIT_REPO_URI="git://gitorious.org/dtsenc/dtsenc.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="
	alsa? ( media-libs/alsa-lib )

"
RDEPEND="
	${DEPEND}
"

AUTOTOOLS_AUTORECONF="1"
#AUTOTOOLS_IN_SOURCE_BUILD="1"

src_configure() {
	local myeconfargs=(
		$(use_enable alsa)
	)
	autotools-utils_src_configure
}

