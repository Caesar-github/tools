#!/system/bin/sh
busybox mv /data/logcat.txt /data/last_logcat.txt
busybox mv /data/kmsg.txt /data/last_kmsg.txt
logcat -v time > /data/logcat.txt&
cat /proc/kmsg > /data/kmsg.txt&

