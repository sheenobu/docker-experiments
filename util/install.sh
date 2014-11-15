
PATH="$PATH:/opt/docker/bin"

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

fleetctl unload vulcand.service
fleetctl destroy vulcand.service
fleetctl load /opt/docker/src/services/main/vulcand.service
fleetctl start vulcand.service

fleetctl unload apache.endpoint.service
fleetctl unload apache@1.service
fleetctl unload apache.1.sk.service
fleetctl unload apache@2.service
fleetctl unload apache.2.sk.service
fleetctl unload apache@3.service
fleetctl unload apache.3.sk.service

fleetctl destroy apache.endpoint.service
fleetctl destroy apache@1.service
fleetctl destroy apache.1.sk.service
fleetctl destroy apache@2.service
fleetctl destroy apache.2.sk.service
fleetctl destroy apache@3.service
fleetctl destroy apache.3.sk.service

fleetctl load /opt/docker/src/services/main/apache@1.service
fleetctl load /opt/docker/src/services/main/apache@2.service
fleetctl load /opt/docker/src/services/main/apache@3.service

fleetctl load /opt/docker/src/services/sidekicks/apache.1.sk.service
fleetctl load /opt/docker/src/services/sidekicks/apache.2.sk.service
fleetctl load /opt/docker/src/services/sidekicks/apache.3.sk.service

fleetctl load /opt/docker/src/services/main/apache.endpoint.service

fleetctl start apache.endpoint.service
