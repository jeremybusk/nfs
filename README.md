install server on fresh ubuntu install
```
```

then

```
curl -LO https://raw.githubusercontent.com/jeremybusk/nfs/main/nfs-k8s-localpath.sh && chmod +x nfs-k8s-localpath.sh
./nfs-k8s-localpath.sh
./nfs-k8s-localpath.sh <uuid> client "a"
```

```
sudo rsync -avzSuc --recursive --delete -e "ssh -l user -i .ssh/id_ed25519" --progress x.x.x.x:/3a2261aa-f0c8-11eb-8ba2-838dc660e293/ /3a2261aa-f0c8-11eb-8ba2-838dc660e293
```
You also could use --relative
