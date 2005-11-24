# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/libtool/libtool-1.5.20.ebuild,v 1.1 2005/09/02 05:06:09 vapier Exp ${P}-r1.ebuild,v 1.8 2002/10/04 06:34:42 kloeri Exp $

inherit eutils libtool

DESCRIPTION="A shared library tool for developers"
HOMEPAGE="http://www.gnu.org/software/libtool/libtool.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND="sys-devel/gnuconfig
	>=sys-devel/autoconf-2.59
	>=sys-devel/automake-1.9"
# the autoconf dep is due to it complaining 'configure.ac:55: error: Autoconf version 2.58 or higher is required'
# the automake dep is due to Bug #46037

lt_setup() {
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.9
}

gen_ltmain_sh() {
	local date=
	local PACKAGE=
	local VERSION=

	rm -f ltmain.shT
	date=`./mkstamp < ./ChangeLog` && \
	eval `egrep '^[[:space:]]*PACKAGE' configure` && \
	eval `egrep '^[[:space:]]*VERSION' configure` && \
	sed -e "s/@PACKAGE@/${PACKAGE}/" -e "s/@VERSION@/${VERSION}/" \
		-e "s%@TIMESTAMP@%$date%" ./ltmain.in > ltmain.shT || return 1

	mv -f ltmain.shT ltmain.sh || {
		(rm -f ltmain.sh && cp ltmain.shT ltmain.sh && rm -f ltmain.shT)
		return 1
	}

	return 0
}

src_unpack() {
	lt_setup
	unpack ${A}
	cd "${S}"

	# Make sure non of the patches touch ltmain.sh, but rather ltmain.in
	rm -f ltmain.sh*

	# Fix the relink problem where the relinked libs do not get
	# installed.  It is *VERY* important that you get a updated
	# 'libtool-1.4.3-relink.patch' if you update this, as it
	# fixes a very serious bug.  Please not that this patch is
	# included in 'libtool-1.4.3-gentoo.patch' for this ebuild.
	#
	# NOTE: all affected apps should get a 'libtoolize --copy --force'
	#      added to update libtool
	#
# Seems to be included in shipped tarball ...
#	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.2-relink-58664.patch

	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.2-multilib.patch
	# Mandrake patches
	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.3-lib64.patch
# Fix bug #43244
#	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.2-fix-linkage-of-cxx-code-with-gcc.patch
	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.2-archive-shared.patch
	epatch "${FILESDIR}"/1.5.6/${PN}-1.5.6-ltmain-SED.patch
	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.2-expsym-linux.patch
	epatch "${FILESDIR}"/1.4.3/${PN}-1.4.3-pass-thread-flags.patch

	# Gentoo Patches
	# Do not create bogus entries in $dependency_libs or $libdir
	# with ${D} or ${S} in them.
	# <azarah@gentoo.org> - (07 April 2002)
	epatch "${FILESDIR}"/1.5.10/${PN}-1.5.10-portage.patch
	# If a package use an older libtool, and libtool.m4 for that
	# package is updated, but not libtool, then we may run into an
	# issue where internal variables are named differently.  Often 
	# this shows up as libs being built without '.so' extension #73140
	epatch "${FILESDIR}"/1.5.20/${PN}-1.5.20-version-checking.patch
	sed -i "s:@_LT_VERSION@:${PV}:" libtool.m4 || die "sed libtool.m4"
	# For older autoconf setups's that do not support libtool.m4,
	# $max_cmd_len are never set, causing all tests against it to
	# fail, resulting in 'integer expression expected' errors and
	# possible misbehaviour.
	# <azarah@gentoo.org> - (11 Feb 2004)
	epatch "${FILESDIR}"/1.5.20/${PN}-1.5.20-ltmain_sh-max_cmd_len.patch

	# Libtool's autoguessing at tag's sucks ... it get's confused 
	# if the tag's CC says '<CHOST>-gcc' and the env CC says 'gcc'
	# or vice versa ... newer automakes specify the tag so no
	# guessing is needed #67692
	epatch "${FILESDIR}"/1.5.6/libtool-1.5-filter-host-tags.patch

	# Libtool uses links to handle locking object files with 
	# dependencies.  Hard links can't cross filesystems though, 
	# so we have to use a diff source for the link.  #40992
	epatch "${FILESDIR}"/1.5.10/libtool-1.5.10-locking.patch

	# In some cases EGREP is not set by the build system.
	epatch "${FILESDIR}"/1.5.14/libtool-1.5.14-egrep.patch

	epatch ${FILESDIR}/1.5.10/${PN}-1.5.10-w32.patch

	ebegin "Generating ltmain.sh"
	gen_ltmain_sh || die "Failed to generate ltmain.sh!"
	eend 0

	# Now let's run all our autotool stuff so that files we patch
	# below don't get regenerated on us later
	cp libtool.m4 acinclude.m4
	local d p
	for d in . libltdl ; do
		ebegin "Running autotools in '${d}'"
		cd ${S}/${d}
		touch acinclude.m4
		for p in aclocal "automake -c -a" autoconf ; do
			${p} || die "${p}"
		done
		eend 0
	done
	cd "${S}"

	uclibctoolize
	epunt_cxx
}

src_compile() {
	lt_setup
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog* NEWS README THANKS TODO doc/PLATFORMS

	for x in $(find "${D}" -name config.guess -o -name config.sub) ; do
		rm -f "${x}" ; ln -sf ../gnuconfig/$(basename "${x}") "${x}"
	done
	cd "${D}"/usr/share/libtool/libltdl
	for x in config.guess config.sub ; do
		rm -f ${x} ; ln -sfn ../${x} ${x}
	done
}
