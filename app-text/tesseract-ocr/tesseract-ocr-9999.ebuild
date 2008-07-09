# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-1.03-r1.ebuild,v 1.6 2007/03/12 14:22:20 gustavoz Exp $

inherit subversion autotools

DESCRIPTION="A commercial quality OCR engine developed at HP in the 80's and early 90's."
HOMEPAGE="http://sourceforge.net/projects/tesseract-ocr/"
ESVN_REPO_URI="http://tesseract-ocr.googlecode.com/svn/trunk"
ESVN_PATCHES="${PN%%-*}*.patch"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-libs/tiff"
RDEPEND="
	${DEPEND}
	!app-text/tesseract
"

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README ReleaseNotes
}
