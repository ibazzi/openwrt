#!/bin/bash

JOBS=`grep -c ^processor /proc/cpuinfo 2>/dev/null`

launch() {
	device=$1
	defconfig="defconfig/"$device"_defconfig"
	[ -f $defconfig ] && {
		echo "launching $device"
		echo "$device" > .device
		cp $defconfig .config
		make defconfig
		return
	}
	echo $device"_defconfig not found"
}

saveconfig() {
	device=`cat .device`
	defconfig="defconfig/"$device"_defconfig"

	echo "saving defconfig for $device"
	scripts/diffconfig.sh > $defconfig
}

showdevice() {
	[ -f .device ] && cat .device
}

m() {
	package=$1

	[ -z $package ] && {
		make -j$JOBS
		return
	}

	make package/$package/compile -j$JOBS
}

