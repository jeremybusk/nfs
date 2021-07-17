#!/usr/bin/env bash
# https://linuxize.com/post/how-to-install-and-configure-an-nfs-server-on-ubuntu-20-04/
set -e
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <uuid> <nfs node type server/client> \"<client ips>\""
  echo "Example: $0 28a1f1f8-e686-11eb-bf45-7f257ca7269b server \"10.x.x.x 10.x.x.y 10.x.x.z\""
  exit
fi

uuid=$1
node_type=$2
client_ips=$3
server_host=nas
server_mnt=/$uuid
server_net_mnt="${server_host}:${server_mnt}"
client_mnt=/opt/local-path-provisioner


if ! [[ $uuid =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
  echo "E: Invalid uuid format."
exit
fi


install_client(){
  echo Installing client.
  sudo sed -i "/$uuid/d" /etc/fstab
  grep $server_mnt /etc/fstab || echo "$server_net_mnt $client_mnt nfs" | sudo tee -a /etc/fstab
  sudo mkdir -p $client_mnt && sudo chmod 0755 $client_mnt
  sudo apt install -y nfs-client  # nfs-common
  sudo mount -a
}


install_server(){
  echo Installing server.
  sudo apt install nfs-kernel-server
  sudo mkdir -p $server_mnt && sudo chmod 0755 $server_mnt
  sudo mv /etc/exports /etc/exports.bkp
  for ip in $client_ips; do
    # risky echo "$server_mnt    $ip(rw,sync,no_subtree_check,insecure,no_root_squash)" | sudo tee -a /etc/exports
    # http://fullyautolinux.blogspot.com/2015/11/nfs-norootsquash-and-suid-basic-nfs.html?m=1
    echo "$server_mnt    $ip(rw,sync,no_subtree_check,insecure,root_squash)" | sudo tee -a /etc/exports
  done
  sudo chmod 0644 /etc/exports
  sudo systemctl reload nfs-server
}


install_localpathprov(){
  # https://github.com/rancher/local-path-provisioner
  kubectl get sc | grep ^local-path && return
  echo "Installing rancher local-path-provisioner in 10 seconds."
  sleep 10
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
  kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pvc/pvc.yaml
  kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pod/pod.yaml
}


if [[ "$node_type" == "server" ]]; then
  install_server
elif [[ "$node_type" == "client" ]]; then
  install_client
  install_localpathprov
else
  echo "E: Unsupported node_type."
fi
