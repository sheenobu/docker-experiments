

cp -f /opt/docker/src/base/docker.service /usr/lib/systemd/system/docker.service
cp -f /opt/docker/src/base/etcd.service /usr/lib/systemd/system/etcd.service
cp -f /opt/docker/src/base/fleetd.service /usr/lib/systemd/system/fleetd.service

systemctl daemon-reload

systemctl enable etcd
systemctl enable docker
systemctl enable fleetd

systemctl start etcd
systemctl start fleetd
systemctl start docker
