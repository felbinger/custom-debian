#!/bin/sh

# ensure dependencies are available
# use `nix shell nixpkgs#{libarchive,libisoburn}` on nix
declare -A cmdPkgMap=(
  [bsdtar]=libarchive-tools
  [xorriso]=xorriso
)

for cmd in "${!cmdPkgMap[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing $cmd, installing..."
    sudo apt install -y "${cmdPkgMap[$cmd]}"
  fi
done

# ensure first parameter is given and is valid file
if [ ${#} -ne 1 ]; then
  echo "Usage: ./prepare-iso.sh {isoImage}"
  echo "Example:"
  echo "./prepare-iso.sh ./debian-13.7.0-amd64-DVD-1.iso"
  exit 1
fi

if [ ! -f "${1}" ]; then
  echo "Unable to find ISO Image: ${1}"
  exit 2
fi

# create a temprorary directory to unpack the iso image
tmp=$(mktemp -d)

echo -n "[*] Unpacking iso..."
bsdtar -C "${tmp}" -xf "${1}"
echo -e "\b\b\b ✓ "

# create preseed configuration for unattended installation
# based on: https://www.debian.org/releases/trixie/example-preseed.txt
echo -n "[*] Adding preseed.cfg..."
mkdir -p "${tmp}/custom"
cat <<_EOF > "${tmp}/custom/preseed.cfg"
d-i netcfg/choose_interface select auto
d-i time/zone string Europe/Berlin
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
d-i passwd/make-user boolean false
d-i passwd/root-password password s3cr3t
d-i passwd/root-password-again password s3cr3t
# ...
_EOF
echo -e "\b\b\b ✓ "

echo -n "[*] Adjusting legacy/csm boot menu..."
chmod +w ${tmp}/isolinux/
cat <<_EOF | tee ${tmp}/isolinux/custom.cfg &>/dev/null
default custom
label custom
  menu label Custom Install
  menu default
  kernel /install.amd/vmlinuz
  append vga=788 initrd=/install.amd/gtk/initrd.gz language=en country=DE locale=en_US.UTF-8 keymap=de net.ifnames=0 auto preseed/file=/cdrom/custom/preseed.cfg --- quiet
_EOF
sed -i '/include menu.cfg/i include custom.cfg' ${tmp}/isolinux/isolinux.cfg
# remove old default
sed -i 's/\tmenu default//' ${tmp}/isolinux/gtk.cfg
# remove speed synthesis
sed -i -e '/timeout/,+3d' ${tmp}/isolinux/spkgtk.cfg
chmod -w ${tmp}/isolinux/
echo -e "\b\b\b ✓ "

echo -n "[*] Adjusting efi boot menu..."
chmod +w ${tmp}/boot/grub
sed -i '/^set theme=\/boot\/grub\/theme\/1$/a\
menuentry "Custom Install" {\
    set background_color=black\
    linux    /install.amd/vmlinuz vga=788 language=en country=DE locale=en_US.UTF-8 keymap=de net.ifnames=0 auto preseed/file=/cdrom/custom/preseed.cfg --- quiet\
    initrd   /install.amd/gtk/initrd.gz\
}' ${tmp}/boot/grub/grub.cfg
chmod -w ${tmp}/boot/grub
echo -e "\b\b\b ✓ "

echo -n "[*] Regenerating hashes..."
cd "${tmp}"
chmod +w md5sum.txt
find -follow -type f ! -name md5sum.txt -print0 2> /dev/null | xargs -0 md5sum > md5sum.txt
chmod -w md5sum.txt
cd ${OLDPWD}
echo -e "\b\b\b ✓ "

echo -n "[*] Repacking iso..."
(
  dd if=${1} bs=1 count=432 of=/tmp/isohdpfx.bin
  xorriso -as mkisofs \
   -r -V 'Custom' \
   -o ./custom.iso \
   -J \
   -J \
   -joliet-long \
   -cache-inodes \
   -isohybrid-mbr /tmp/isohdpfx.bin \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat \
   -boot-load-size 4 \
   -boot-info-table \
   -no-emul-boot \
   -eltorito-alt-boot \
   -e boot/grub/efi.img \
   -no-emul-boot \
   -isohybrid-gpt-basdat \
   -isohybrid-apm-hfsplus \
   ${tmp}
) &> /dev/null && echo -e "\b\b\b ✓ "

# remove the temporary directory in which we unpacked the iso
chmod -R ug+w "${tmp}"
rm -r "${tmp}"
