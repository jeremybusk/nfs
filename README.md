install server on fresh ubuntu install
```
```

then

```
curl -LO https://raw.githubusercontent.com/jeremybusk/nfs/main/nfs-k8s-localpath.sh && chmod +x nfs-k8s-localpath.sh
./nfs-k8s-localpath.sh
./nfs-k8s-localpath.sh <uuid> client "a"
```

/etc/exports
```
/3a2261aa-f0c8-11eb-8ba2-838dc660e293    192.168.x.x(rw,sync,no_subtree_check,insecure,root_squash)
```

/etc/fstab NFS4
```
# 192.x.x.x:/3a2261aa-f0c8-11eb-8ba2-838dc660e293 /opt/local-path-provisioner  nfs
192.x.x.x:/3a2261aa-f0c8-11eb-8ba2-838dc660e293/opt/local-path-provisioner  nfs4  _netdev,auto  0  0
```
Replication from one host to another or dirs
```
sudo rsync -avzSuc --recursive --dry-run --delete -e "ssh -l user -i .ssh/id_ed25519" --progress x.x.x.x:/3a2261aa-f0c8-11eb-8ba2-838dc660e293/ /3a2261aa-f0c8-11eb-8ba2-838dc660e293
```
- Remove --dry-run to execute
- You also could use --relative to do relative pathing


# NFS 4 Only
```
Enable verion 4 only by disabling 2 and 3 (2 is already disabled on modern os) - https://wiki.debian.org/NFSServerSetup - https://help.ubuntu.com/community/NFSv4Howto

/etc/default/nfs-kernel-server # update

# RPCMOUNTDOPTS="--manage-gids"
RPCMOUNTDOPTS="--manage-gids -N 2 -N 3"
RPCNFSDOPTS="-N 2 -N 3"
/etc/default/nfs-common # add

NEED_STATD="no"
NEED_IDMAPD="yes"
sudo systemctl mask rpcbind.service
sudo systemctl mask rpcbind.socket
sudo cat /proc/fs/nfsd/versions
sudo systemctl restart nfs-server
sudo cat /proc/fs/nfsd/versions
showmount -e nas
does not work now

and all traffic goes over 2049 unencrypted with only ip address access restrictions. Very simple, very fast.

/etc/exports

/101f8f6a-e761-11eb-8e23-afa707071684    192.168.1.10(rw,sync,no_subtree_check,insecure,root_squash)
/etc/fstab

nfshost:/101f8f6a-e761-11eb-8e23-afa707071684 /opt/localnfshare nfs4  _netdev,auto  0  0
```
