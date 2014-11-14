

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

fleetctl load /opt/docker/src/services/experiment1.service

fleetctl load /opt/docker/src/services/main/vulcand.service

fleetctl load /opt/docker/src/services/data/apache.1.data.service
fleetctl load /opt/docker/src/services/data/apache.2.data.service
fleetctl load /opt/docker/src/services/data/apache.3.data.service

fleetctl load /opt/docker/src/services/main/apache.1.service
fleetctl load /opt/docker/src/services/main/apache.2.service
fleetctl load /opt/docker/src/services/main/apache.3.service

fleetctl load /opt/docker/src/services/sidekicks/apache.1.sk.service
fleetctl load /opt/docker/src/services/sidekicks/apache.2.sk.service
fleetctl load /opt/docker/src/services/sidekicks/apache.3.sk.service

fleetctl start experiment1
