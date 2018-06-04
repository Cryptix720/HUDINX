#!/bin/sh

echo -e "Do you want to uninstall HUDINX (yes/no)? "
read res 

if [ $res = 'yes' ]; then
	echo Uninstalling ...
	echo

	daemon_alive=`ps aux | grep /usr/bin/hudinxd | grep -v grep | wc -l `

	if [ $daemon_alive -gt 0 ]; then
		echo Stopping hudinx daemon ...

		if [ -f /etc/init.d/hudinx ]; then
			/etc/init.d/hudinx stop
		else
			echo "Can't find a method to kill the daemon. Kill it manually."
			exit -1
		fi
		echo Waiting for a while
		sleep 3
	fi

	echo Removing main directory
	rm -fr /usr/share/hudinx

	echo Removing /etc/hudinx directory
	rm -fr /etc/hudinx

	echo Removing startup script
	rm -f /etc/init.d/hudinx

	echo Removing symlinks
	rm -f /usr/bin/hudinxd /usr/bin/HUDXreport /usr/bin/HUDXreport-filter /usr/bin/hudinxcountry \
	/usr/bin/kojhumans /usr/bin/HUDXsession

	echo Uninstall finished
fi
