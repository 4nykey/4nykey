# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC="man"
inherit ruby-fakegem
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/defunkt/gist.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/all/${P}"
	SRC_URI=""
else
	SRC_URI="mirror://githubcl/defunkt/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	RESTRICT="primaryuri"
fi
RESTRICT+=" test"

DESCRIPTION="Upload code to gist.github.com"
HOMEPAGE="http://defunkt.io/gist"

LICENSE="MIT"
SLOT="0"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/webmock:*
"
ruby_add_bdepend "
	doc? ( app-text/ronn )
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
