#!/bin/bash

# ensure dependencies are available
declare -A cmdPkgMap=(
  [lb]=live-build
)

for cmd in "${!cmdPkgMap[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing $cmd, installing..."
    sudo apt install -y "${cmdPkgMap[$cmd]}"
  fi
done

# initialize configuration directory
tmp=$(mktemp -d)
cd ${tmp}
lb config

# add packages that should be vendored into the iso image
cat <<_EOF > ./config/package-lists/additional-packages.list.chroot
htop
_EOF

# add hooks to be performed on startup
cat <<_EOF > ./config/hooks/live/0100-adjustments.hook.chroot
#!/bin/bash

cat <<_EOF >> /root/.bashrc

if tty | grep -q tty1
then
  htop
fi
_EOF

# finally build the image
lb build
