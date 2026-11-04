# customized debian

This repository contains different ways to create a customized debian iso.

You can either adjust pre build iso images:
- using shell script, see [`script`](https://github.com/felbinger/custom-debian/tree/script),
- using ansible-playbook, see [`ansible`](https://github.com/felbinger/custom-debian/tree/ansible) or,
- using github actions compatible workflow, see [`ci`](https://github.com/felbinger/custom-debian/tree/ci).

Or use `live-build` to build a minimal debian iso from scratch, see [`live-build-script`](https://github.com/felbinger/custom-debian/tree/live-build-script).

## ansible
```sh
ansible-playbook prepare-iso.yaml --ask-become-pass
```
```
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Prepare customized ISO] ****************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************
ok: [localhost]

TASK [Install additional packages] ***********************************************************************************************************
ok: [localhost]

TASK [Create tmp directory] ******************************************************************************************************************
changed: [localhost]

TASK [Unpack iso] ****************************************************************************************************************************
changed: [localhost]

TASK [Create custom directory] ***************************************************************************************************************
changed: [localhost]

TASK [Create preseed.cfg] ********************************************************************************************************************
changed: [localhost]

TASK [Make isolinux writeable] ***************************************************************************************************************
changed: [localhost]

TASK [Create custom boot config] *************************************************************************************************************
changed: [localhost]

TASK [Include custom isolinux configuration] *************************************************************************************************
changed: [localhost]

TASK [Remove original default menu entry] ****************************************************************************************************
changed: [localhost]

TASK [Remove automatic start of speech synthesis] ********************************************************************************************
changed: [localhost]

TASK [Make isolinux unwriteable] *************************************************************************************************************
changed: [localhost]

TASK [Make grub.cfg writeable] ***************************************************************************************************************
changed: [localhost]

TASK [Adjust grub configuration] *************************************************************************************************************
changed: [localhost]

TASK [Make grub.cfg unwriteable] *************************************************************************************************************
changed: [localhost]

TASK [Make md5sum.txt writeable] *************************************************************************************************************
changed: [localhost]

TASK [Regenerate hashes] *********************************************************************************************************************
changed: [localhost]

TASK [Make md5sum.txt unwriteable] ***********************************************************************************************************
changed: [localhost]

TASK [Extract isohdpfx.bin] ******************************************************************************************************************
changed: [localhost]

TASK [Repack iso] ****************************************************************************************************************************
changed: [localhost]

TASK [Make temp dir writeable] ***************************************************************************************************************
changed: [localhost]

TASK [Cleanup temp dir] ********************************************************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************************************************************************************************************************************************************************************************************************
localhost                  : ok=21   changed=19   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
