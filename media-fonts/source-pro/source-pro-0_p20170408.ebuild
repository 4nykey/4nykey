# Copyright 1999-2017 Gentoo Foundation
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
IUSE="cjk emoji +monospace +sans +serif"

RDEPEND="
	cjk? (
		sans? ( media-fonts/source-han-sans )
		serif? ( media-fonts/source-han-serif )
	)
	emoji? ( media-fonts/source-emoji )
	monospace? ( media-fonts/source-code-pro )
	serif? ( media-fonts/source-serif-pro )
	sans? ( media-fonts/source-sans-pro )
"
