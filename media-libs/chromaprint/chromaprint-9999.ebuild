# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils cmake-utils git-r3

DESCRIPTION="Core component of the Acoustid audio fingerprinting project."
HOMEPAGE="http://acoustid.org/chromaprint"
EGIT_REPO_URI="https://bitbucket.org/acoustid/${PN}.git"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="tools fftw"
DEPEND="
	fftw? ( sci-libs/fftw:3.0 )
	!fftw? ( virtual/ffmpeg )
	tools? ( virtual/ffmpeg )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with fftw FFTW3)
		$(cmake-utils_use_build tools EXAMPLES)
	)
	cmake-utils_src_configure
}
