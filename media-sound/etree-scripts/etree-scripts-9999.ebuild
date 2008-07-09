# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module subversion

DESCRIPTION="A set of (mostly) Perl scripts for lossless audio"
HOMEPAGE="http://etree-scripts.sourceforge.net/"
ESVN_REPO_URI="https://etree-scripts.svn.sourceforge.net/svnroot/etree-scripts/trunk/etree-scripts"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86"
IUSE="shorten flac mp3 vorbis cdr"

DEPEND="
	dev-perl/TimeDate
	virtual/perl-Digest-MD5
	dev-perl/Audio-Wav
	dev-perl/HTML-Parser
"
RDEPEND="
	${DEPEND}
	media-sound/shntool
	shorten? ( media-sound/shorten )
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )
	vorbis? ( media-sound/vorbis-tools )
	cdr? ( app-cdr/cdrtools )
"
