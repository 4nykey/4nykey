# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/Fraunhofer-IIS/${PN}.git"
	inherit git-r3
else
	MY_PV="b8cb3eb"
	[[ -n ${PV%%*_p*} ]] && MY_PV="r${PV}"
	SRC_URI+="
		mirror://githubcl/Fraunhofer-IIS/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
	RESTRICT="primaryuri"
fi

DESCRIPTION="A collection of helpful datatypes and algorithms for MPEG-H software"
HOMEPAGE="https://github.com/Fraunhofer-IIS/${PN}"

LICENSE="FraunhoferFDK"
SLOT="0"
