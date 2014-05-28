#!/bin/bash -x

# Nuxeo setup

nuxeouid=$(grep nuxeo /etc/passwd | cut -d: -f3)
nuxeogid=$(grep nuxeo /etc/passwd | cut -d: -f4)

mkdir -p /var/lib/nuxeo

mkdir -p /tmp/nuxeo-distribution
unzip -q -d /tmp/nuxeo-distribution nuxeo-distribution.zip
distdir=$(/bin/ls /tmp/nuxeo-distribution | head -n 1)
mv /tmp/nuxeo-distribution/$distdir /var/lib/nuxeo/server
rm -rf /tmp/nuxeo-distribution
chmod +x /var/lib/nuxeo/server/bin/nuxeoctl
echo "org.nuxeo.distribution.packaging=vm" >> /var/lib/nuxeo/server/templates/common/config/distribution.properties

mkdir -p /etc/nuxeo
mv /var/lib/nuxeo/server/bin/nuxeo.conf /etc/nuxeo/nuxeo.conf

mkdir -p /var/log/nuxeo

chown -R $nuxeouid:$nuxeogid /var/lib/nuxeo
chown -R $nuxeouid:$nuxeogid /etc/nuxeo
chown -R $nuxeouid:$nuxeogid /var/log/nuxeo

cat << EOF >> /etc/nuxeo/nuxeo.conf
nuxeo.log.dir=/var/log/nuxeo
nuxeo.pid.dir=/var/run/nuxeo
nuxeo.data.dir=/var/lib/nuxeo/data
nuxeo.wizard.done=true
EOF

mkdir -p /var/run/nuxeo
chown $NUXEO_USER:$NUXEO_USER /var/run/nuxeo



