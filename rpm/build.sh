#!/bin/bash
set -e
export VERSION=$(cat VERSION)
export promdir=prometheus-lustre-exporter-$VERSION
export builddir=$HOME/rpmbuild
make
#use VERSION File as Version
sed -i "s/VERSION/$(cat VERSION)/" rpm/prometheus-lustre-exporter.spec
mkdir -p $builddir/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
mkdir -p $builddir/SOURCES/$promdir/usr/bin
mkdir -p $builddir/SOURCES/$promdir/usr/lib/systemd/system
mkdir -p $builddir/SOURCES/$promdir/etc/sysconfig
cp rpm/prometheus-lustre-exporter.spec $builddir/SPECS/
cp systemd/prometheus-lustre-exporter.service $builddir/SOURCES/$promdir/usr/lib/systemd/system/prometheus-lustre-exporter.service
cp systemd/prometheus-lustre-exporter.options $builddir/SOURCES/$promdir/etc/sysconfig
cp lustre_exporter $builddir/SOURCES/$promdir/usr/bin
cd $builddir/SOURCES
tar -czvf $promdir.tar.gz $promdir
cd $builddir
echo build dir is $builddir
ls -la $builddir/SOURCES
rpmbuild -ba  $builddir/SPECS/prometheus-lustre-exporter.spec

