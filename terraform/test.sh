for i in $(podman images)
do
podman rmi --force $i
done
