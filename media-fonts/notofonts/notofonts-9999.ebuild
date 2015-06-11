# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font git-r3

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"
EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts.git"

LICENSE="Apache-2.0 cjk? ( OFL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk"

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttc"
use cjk && FONT_SUFFIX="${FONT_SUFFIX} otf"
DOCS="*.md CONTRIBUTORS noto_cjk/HISTORY noto_cjk/NEWS noto_cjk/README*"

src_unpack() {
	git-r3_src_unpack
	use cjk && \
	EGIT_CHECKOUT_DIR="${S}/noto_cjk" \
	EGIT_REPO_URI="https://github.com/googlei18n/noto-cjk.git" \
		git-r3_src_unpack
}

src_prepare() {
	mv hinted/Noto*.ttc .
	use cjk && mv noto_cjk/NotoSans[JKST]*.otf .
}
