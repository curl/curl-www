#!/bin/sh

# One-time database upgrade. Delete this script after a successful run.

f="${1:-data/databas.db}"

# TODO: Add these logos to the appropriate lines:
#
# chromenacl.svg
# docker.svg
# illumos.svg
# maemo.svg

# Keep lengths the same to not corrupt the database.
sed -i.bak \
  -e 's/aix\.png/aix.svg/g'                 \
  -e 's/alpine\.png/alpine.svg/g'           \
  -e 's/altlinux\.png/altlinux.svg/g'       \
  -e 's/amiga\.png/amiga.svg/g'             \
  -e 's/arch\.png/arch.svg/g'               \
  -e 's/archhurd\.png/archhurd.svg/g'       \
  -e 's/beos\.png/beos.svg/g'               \
  -e 's/clear\.png/clear.svg/g'             \
  -e 's/coreos\.png/coreos.svg/g'           \
  -e 's/cygwin\.png/cygwin.svg/g'           \
  -e 's/debian\.png/debian.svg/g'           \
  -e 's/devuan\.png/devuan.svg/g'           \
  -e 's/dos\.png/dos.svg/g'                 \
  -e 's/fedora\.png/fedora.svg/g'           \
  -e 's/freebsd\.png/freebsd.svg/g'         \
  -e 's/frugalware\.png/frugalware.svg/g'   \
  -e 's/gentoo\.png/gentoo.svg/g'           \
  -e 's/gobolinux\.png/gobolinux.svg/g'     \
  -e 's/guix\.png/guix.svg/g'               \
  -e 's/haiku\.png/haiku.svg/g'             \
  -e 's/hpux\.png/hpux.svg/g'               \
  -e 's/irix\.png/irix.svg/g'               \
  -e 's/linux\.png/linux.svg/g'             \
  -e 's/macosx\.png/macosx.svg/g'           \
  -e 's/mageia\.png/mageia.svg/g'           \
  -e 's/netbsd\.png/netbsd.svg/g'           \
  -e 's/nixos\.png/nixos.svg/g'             \
  -e 's/oe\.png/oe.svg/g'                   \
  -e 's/openindiana\.png/openindiana.svg/g' \
  -e 's/openserver\.png/openserver.svg/g'   \
  -e 's/openwrt\.png/openwrt.svg/g'         \
  -e 's/os2\.png/os2.svg/g'                 \
  -e 's/pld\.png/pld.svg/g'                 \
  -e 's/qnx\.png/qnx.svg/g'                 \
  -e 's/redhat\.png/redhat.svg/g'           \
  -e 's/riscos\.png/riscos.svg/g'           \
  -e 's/sailfishos\.png/sailfishos.svg/g'   \
  -e 's/slackware\.png/slackware.svg/g'     \
  -e 's/slitaz\.png/slitaz.svg/g'           \
  -e 's/solaris\.png/solaris.svg/g'         \
  -e 's/suse\.png/suse.svg/g'               \
  -e 's/t2\.png/t2.svg/g'                   \
  -e 's/tizen\.png/tizen.svg/g'             \
  -e 's/ubuntu\.png/ubuntu.svg/g'           \
  -e 's/unixware\.png/unixware.svg/g'       \
  -e 's/vms\.png/vms.svg/g'                 \
  -e 's/win32\.png/win32.svg/g'             "${f}"
