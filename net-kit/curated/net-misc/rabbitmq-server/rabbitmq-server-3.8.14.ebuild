# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3+ )

inherit python-any-r1 user

DESCRIPTION="RabbitMQ is a high-performance AMQP-compliant message broker written in Erlang"
HOMEPAGE="https://www.rabbitmq.com/"
SRC_URI="https://github.com/rabbitmq/rabbitmq-server/releases/download/v${PV}/rabbitmq-server-${PV}.tar.xz"

LICENSE="GPL-2 MPL-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-lang/erlang-22.3[ssl]
	<dev-lang/erlang-24[ssl]"
DEPEND="${RDEPEND}
	app-arch/zip
	app-arch/unzip
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	>=dev-lang/elixir-1.8.0
	<dev-lang/elixir-1.12.0
	dev-libs/libxslt
	$(python_gen_any_dep 'dev-python/simplejson[${PYTHON_USEDEP}]')
"
src_prepare() {
	default
}

pkg_setup() {
	enewgroup rabbitmq
	enewuser rabbitmq -1 -1 /var/lib/rabbitmq rabbitmq
	python-any-r1_pkg_setup
}

src_compile() {
	emake all docs dist
}

src_install() {
	# erlang module
	local targetdir="/usr/$(get_libdir)/erlang/lib/rabbitmq_server-${PV}"

	einfo "Setting correct RABBITMQ_HOME in scripts"
	sed -e "s:^RABBITMQ_HOME=.*:RABBITMQ_HOME=\"${targetdir}\":g" \
		-i deps/rabbit/scripts/rabbitmq-env || die

	einfo "Installing Erlang modules to ${targetdir}"
	insinto "${targetdir}"
	doins -r deps/rabbit/ebin deps/rabbit/include deps/rabbit/priv escript plugins

	einfo "Installing server scripts to /usr/sbin"
	rm -v deps/rabbit/scripts/*.bat
	exeinto /usr/libexec/rabbitmq
	for script in deps/rabbit/scripts/*; do
		doexe ${script}
		newsbin "${FILESDIR}"/rabbitmq-script-wrapper $(basename $script)
	done

	# install the init script
	newinitd "${FILESDIR}"/rabbitmq-server.init-r4 rabbitmq

	# install documentation
	dodoc deps/rabbit/docs/*.example
	dodoc deps/rabbit/README.md
	doman deps/rabbit/docs/*.5
	doman deps/rabbit/docs/*.8

	# create the directory where our log file will go.
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/log/rabbitmq /etc/rabbitmq

	# create the mnesia directory
	diropts -m 0770 -o rabbitmq -g rabbitmq
	keepdir /var/lib/rabbitmq{,/mnesia}
}
