# customized debian

This repository contains different ways to create a customized debian iso.

You can either adjust pre build iso images:
- using shell script, see [`script`](https://github.com/felbinger/custom-debian/tree/script),
- using ansible-playbook, see [`ansible`](https://github.com/felbinger/custom-debian/tree/ansible) or,
- using github actions compatible workflow, see [`ci`](https://github.com/felbinger/custom-debian/tree/ci).

Or use `live-build` to build a minimal debian iso from scratch, see [`live-build-script`](https://github.com/felbinger/custom-debian/tree/live-build-script).

## live-build-script
```sh
bash ./build.sh
```
```
[2026-11-06 00:46:19] lb config 
P: Creating config tree for a debian/testing/amd64 system
P: Symlinking hooks...
[2026-11-06 00:46:19] lb build 
P: live-build 20250505+deb13u1
P: Building for a debian/testing/amd64 system
[2026-11-06 00:46:19] lb bootstrap 
P: Setting up clean exit handler
[2026-11-06 00:46:19] lb bootstrap_cache restore
[2026-11-06 00:46:19] lb bootstrap_debootstrap 
P: Begin bootstrapping system...
P: If the following stage fails, the most likely cause of the problem is with your mirror configuration or a caching proxy.
P: Running debootstrap (download-only)...
I: Retrieving InRelease 

```
