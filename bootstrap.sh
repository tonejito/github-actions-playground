#!/bin/bash
#	= ^ . ^ =

DPKG_CONF_LOCAL=/etc/dpkg/dpkg.cfg.d/99-local
APT_CONF_LOCAL=/etc/apt/apt.conf.d/99-local

PANDOC_TAR_URL="https://github.com/jgm/pandoc/releases/download/3.1.2/pandoc-3.1.2-linux-amd64.tar.gz"
PANDOC_TAR="/tmp/pandoc.tar.gz"

export PAGER="cat"
export TERM="linux"
export DEBIAN_PRIORITY="critical"
export DEBIAN_FRONTEND="noninteractive"
export DEBCONF_NOWARNINGS="yes"
export DEBCONF_TERSE="yes"
export DEBCONF_NONINTERACTIVE_SEEN="true"

# FIXME: WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

# PIP_OPTS="--user"
PIP_OPTS="${PIP_OPTS}"

set -o pipefail
set -evxu

mkdir -vp $(dirname "${APT_CONF_LOCAL}")
truncate --size=0 "${APT_CONF_LOCAL}"
cat > "${APT_CONF_LOCAL}" << EOF
quiet "2";
APT::Get::Assume-Yes "1";
APT::Install-Recommends "0";
APT::Install-Suggests "0";
APT::Color "0";
Dpkg::Progress "0";
Dpkg::Progress-Fancy "0";
Dpkg::Use-Pty "0";
EOF

# FIXME: WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
apt-get -q=2 update
apt-get -qq install make git wget

pip3 config --global set global.quiet 1
pip3 config --global set global.progress_bar off
pip3 install ${PIP_OPTS} --upgrade pip

pip3 install ${PIP_OPTS} pre-commit

if [ -f requirements.txt ]
then
  pip3 install ${PIP_OPTS} --requirement requirements.txt
fi

# https://pandoc.org/installing.html#linux
# Install pandoc from TAR
wget -c -nv -O "${PANDOC_TAR}" "${PANDOC_TAR_URL}"
tar -xzf "${PANDOC_TAR}" --strip-components 1 -C /usr/local
rm -v "${PANDOC_TAR}"

which python3 pip3 make git pre-commit pandoc
whereis python3 pip3 make git pre-commit pandoc

python3 --version
pip3 --version
make --version
git --version
pre-commit --version
pandoc --version
