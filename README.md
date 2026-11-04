# customized debian

This repository contains different ways to create a customized debian iso.

You can either adjust pre build iso images:
- using shell script, see [`script`](https://github.com/felbinger/custom-debian/tree/script),
- using ansible-playbook, see [`ansible`](https://github.com/felbinger/custom-debian/tree/ansible) or,
- using github actions compatible workflow, see [`ci`](https://github.com/felbinger/custom-debian/tree/ci).

Or use `live-build` to build a minimal debian iso from scratch, see [`live-build-script`](https://github.com/felbinger/custom-debian/tree/live-build-script).

## script
```sh
sh ./prepare-iso.sh /iso/debian-13.7.0-amd64-DVD-1.iso
```
```
[*] Unpacking iso ✓ 
[*] Adding preseed.cfg ✓ 
[*] Adjusting legacy/csm boot menu ✓ 
[*] Adjusting efi boot menu ✓ 
[*] Regenerating hashes ✓ 
[*] Repacking iso ✓ 
```
