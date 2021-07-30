# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="
	http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk emoji +font_variants_monospace +font_variants_sans +font_variants_serif l10n_ja"

RDEPEND="
	cjk? (
		font_variants_sans? ( media-fonts/source-han-sans )
		font_variants_serif? ( media-fonts/source-han-serif )
		font_variants_monospace? ( media-fonts/source-han-mono )
	)
	emoji? ( media-fonts/source-emoji )
	font_variants_monospace? (
		media-fonts/source-code-pro
		l10n_ja? ( media-fonts/source-han-code-jp )
	)
	font_variants_serif? ( media-fonts/source-serif-pro )
	font_variants_sans? ( media-fonts/source-sans-pro )
"
