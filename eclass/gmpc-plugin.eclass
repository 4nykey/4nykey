inherit subversion autotools

DESCRIPTION="${PN/gmpc-/} plugin for GMPC"
HOMEPAGE="http://sarine.nl/gmpc-plugins"
ESVN_REPO_URI="https://svn.musicpd.org/gmpc/plugins/${PN}/trunk"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	~media-sound/gmpc-9999
"
DEPEND="
	${RDEPEND}
"

gmpc-plugin_src_install() {
	einstall || die "Install failed"
	[ -n ${DOCS} ] && dodoc ${DOCS}
}

EXPORT_FUNCTIONS src_install
