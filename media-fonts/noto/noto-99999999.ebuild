# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary cjk emoji font_variants_monospace +font_variants_sans font_variants_serif"

DEPEND=""
RDEPEND="
	binary? ( media-fonts/noto-fonts )
	!binary? ( media-fonts/noto-source )
	cjk? (
		font_variants_sans? (
			media-fonts/noto-cjk-sans[font_variants_monospace?]
		)
		font_variants_serif? (
			media-fonts/noto-cjk-serif
		)
	)
	emoji? ( media-fonts/noto-emoji )
"
REQUIRED_USE="
cjk? (
	|| ( font_variants_monospace font_variants_sans font_variants_serif )
)
"
