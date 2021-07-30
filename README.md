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
/3a2261aa-f0c8-11eb-8ba2-838dc660e293    172.16.1.135(rw,sync,no_subtree_check,insecure,root_squash)
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
