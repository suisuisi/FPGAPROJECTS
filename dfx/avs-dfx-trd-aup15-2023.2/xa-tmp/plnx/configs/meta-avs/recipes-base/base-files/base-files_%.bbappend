FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:${PN} += "bash"

do_install:append () {
	sed -i "/PATH=\"\/usr/a\export HOME=\/home\/root" ${D}${sysconfdir}/profile

	echo "alias ls='ls --color=auto'" >> ${D}${sysconfdir}/profile
	echo "alias ll='ls --color=auto -l'" >> ${D}${sysconfdir}/profile
	echo "alias la='ls --color=auto -la'" >> ${D}${sysconfdir}/profile

#	if [[ "${RDEPENDS_${PN}}" =~ "resolvconf" ]]; then
#		echo "resolvconf -u" >> ${D}${sysconfdir}/profile
#	fi

	echo "export PS1=\"\[\e[31m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]# \"" >> ${D}${sysconfdir}/profile
}

