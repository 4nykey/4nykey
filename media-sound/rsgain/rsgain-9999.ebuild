# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/complexlogic/${PN}.git"
else
	MY_PV="5697031"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="v${PV}"
		SRC_URI="
			https://github.com/complexlogic/${PN}/releases/download/${MY_PV}/${P}-source.tar.xz
		"
	else
		SRC_URI="
			mirror://githubcl/complexlogic/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="ReplayGain 2.0 loudness normalizer"
HOMEPAGE="https://github.com/complexlogic/${PN}"

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	media-video/ffmpeg:=
	media-libs/taglib
	media-libs/libebur128
	dev-libs/inih
	dev-libs/libfmt:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
