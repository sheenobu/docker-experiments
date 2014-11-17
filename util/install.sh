
PATH="$PATH:/opt/docker/bin"

cp -f /opt/docker/src/base/docker.service /usr/lib/systemd/system/docker.service
cp -f /opt/docker/src/base/etcd.service /usr/lib/systemd/system/etcd.service
cp -f /opt/docker/src/base/fleetd.service /usr/lib/systemd/system/fleetd.service
cp -f /opt/docker/src/base/fleetweb.service /usr/lib/systemd/system/fleetweb.service
cp -f /opt/docker/src/base/kicker.service /usr/lib/systemd/system/kicker.service


systemctl daemon-reload

systemctl enable etcd
systemctl enable docker
systemctl enable fleetd
systemctl enable fleetweb
systemctl enable kicker

systemctl start etcd
systemctl start fleetd
systemctl start docker
systemctl start fleetweb
systemctl start kicker

fleetctl unload vulcand.service
fleetctl load /opt/docker/src/services/main/vulcand.service
fleetctl start vulcand.service

fleetctl destroy apache.endpoint.service
fleetctl destroy apache@1.service
fleetctl destroy apache@2.service
fleetctl destroy apache@3.service

fleetctl destroy apache.sk@1.service
fleetctl destroy apache.sk@2.service
fleetctl destroy apache.sk@3.service

fleetctl destroy apache.hc@1.timer
fleetctl destroy apache.hc@2.timer
fleetctl destroy apache.hc@3.timer

fleetctl destroy apache.hc@1.service
fleetctl destroy apache.hc@2.service
fleetctl destroy apache.hc@3.service

fleetctl unload apache.endpoint.service
fleetctl unload apache@1.service
fleetctl unload apache@2.service
fleetctl unload apache@3.service

fleetctl unload apache.sk@1.service
fleetctl unload apache.sk@2.service
fleetctl unload apache.sk@3.service

fleetctl unload apache.hc@1.timer
fleetctl unload apache.hc@2.timer
fleetctl unload apache.hc@3.timer

fleetctl unload apache.hc@1.service
fleetctl unload apache.hc@2.service
fleetctl unload apache.hc@3.service

fleetctl load /opt/docker/src/services/main/apache@1.service
fleetctl load /opt/docker/src/services/main/apache@2.service
fleetctl load /opt/docker/src/services/main/apache@3.service

fleetctl load /opt/docker/src/services/sidekicks/apache.sk@1.service
fleetctl load /opt/docker/src/services/sidekicks/apache.sk@2.service
fleetctl load /opt/docker/src/services/sidekicks/apache.sk@3.service

fleetctl load /opt/docker/src/services/healthchecks/apache.hc@1.service
fleetctl load /opt/docker/src/services/healthchecks/apache.hc@2.service
fleetctl load /opt/docker/src/services/healthchecks/apache.hc@3.service

fleetctl load /opt/docker/src/services/timer/apache.hc@1.timer
fleetctl load /opt/docker/src/services/timer/apache.hc@2.timer
fleetctl load /opt/docker/src/services/timer/apache.hc@3.timer

fleetctl load /opt/docker/src/services/main/apache.endpoint.service

fleetctl start apache.endpoint.service
