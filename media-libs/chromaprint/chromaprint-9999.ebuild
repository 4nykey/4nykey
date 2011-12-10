# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils cmake-utils git-2

DESCRIPTION="Core component of the Acoustid audio fingerprinting project."
HOMEPAGE="http://acoustid.org/chromaprint"
EGIT_REPO_URI="git://github.com/lalinsky/chromaprint.git"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples fftw"
DEPEND="
	fftw? ( sci-libs/fftw:3.0 )
	!fftw? ( virtual/ffmpeg )
	examples? ( virtual/ffmpeg )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_with fftw FFTW3)
		$(cmake-utils_use_build examples)
	"
	cmake-utils_src_configure
}
