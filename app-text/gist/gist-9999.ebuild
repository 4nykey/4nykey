# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"
RUBY_FAKEGEM_EXTRADOC="README.md"
inherit ruby-fakegem
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/defunkt/gist.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/all/${P}"
	SRC_URI=""
else
	SRC_URI="mirror://githubcl/defunkt/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Upload code to gist.github.com"
HOMEPAGE="http://defunkt.io/gist"

LICENSE="MIT"
SLOT="0"
IUSE=""

ruby_add_rdepend "
	dev-ruby/json:2
	dev-ruby/webmock:2
"

all_ruby_prepare() {
	sed -e '/git ls-files/d' -i ${PN}.gemspec
	[[ -z ${PV%%*9999} ]] && \
	RUBY_FAKEGEM_VERSION="$(awk -F\' '/VERSION = / {print $2}' build/gist)"
}

all_ruby_install() {
	all_fakegem_install
	doman build/${PN}.1
}
