#!/bin/sh /etc/rc.common
START=20
STOP=90
ENABLE_DEBUG_OUTPUT=0

drv_obj_file_name=drv_event_logger
bindir=/opt/lantiq/bin

KERNEL_VERSION=`uname -r`
KERNEL_MAJOR=`uname -r | cut -f1,2 -d. | sed -e 's/\.//'`

# check for Linux 2.6 or higher
if [ $KERNEL_MAJOR -ge 26 ]; then
        MODEXT=.ko
fi

modules_dir=/lib/modules/${KERNEL_VERSION}

start() {
   # load IFXOS if not already loaded
   [ -e ${modules_dir}/drv_ifxos$MODEXT ] &&
   [ -z `cat /proc/modules | grep drv_ifxos` ] && {
      insmod ${modules_dir}/drv_ifxos$MODEXT
   }
   # install event logger
   cd ${bindir}
   [ -e ${bindir}/inst_driver.sh ] && {
      ${bindir}/inst_driver.sh $ENABLE_DEBUG_OUTPUT $drv_obj_file_name $drv_obj_file_name
      mknod /dev/evlog-misc c 10 100;
   }
}

stop() {
   rmmod $drv_obj_file_name$MODEXT
}

