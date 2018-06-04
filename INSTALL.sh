#!/bin/sh -x

function die
{
	echo Error at $1
	echo 
	echo hudinx installation failed
	exit 1
}

function cdwin(){
    echo "I receive the variable --> $1"
    line=$(sed -e 's#^E:##' -e 's#\\#/#g' <<< "$1")
    cd "$line"
}

hudinx_PATH=/usr/share/hudinx

echo HUDINX installer. 
echo
echo "Press enter to view the license agreement(s) ..."
read
more LICENSE libs/license.zop libs/twisted.license 2>/dev/null || less LICENSE libs/license.zop libs/twisted.license 

echo -e "Do you accept the ZPL, MIT and GPL license terms (yes/no) ?"
read license_accept

#
# Bug 1463831
#
#if [ "$license_accept" = 'yes' ]; then
#
if [ "$license_accept" = 'yes' ]; then
	echo All licenses accepted
	echo
	clear
	echo "******************************************"
	echo " HUDINX Installer version 0.0.1 "
	echo "******************************************"
	echo
else
	echo You need to accept ALL the licenses to install it.
	echo Exiting...
	echo
	exit
fi

if [ -d $hudinx_PATH ]; then
	echo Directory exists. Uninstall it first.
	echo Exiting...
	exit
else
	mkdir $hudinx_PATH
fi

if [ -d /etc/hudinx ]; then
	echo -e "WARNING! Directory /etc/hudinx exists!"
else
	mkdir /etc/hudinx
fi

echo "Step 1 - Copying files"
cp *.py* $hudinx_PATH
cp fake_users /etc/hudinx
cp -f reports/* $hudinx_PATH 2>/dev/null
temp_dir=`mktemp -d`
echo " [+] Working on temp directory $temp_dir"
echo " [+] Copying base libraries"
cp -f libs/* $temp_dir 
echo " [+] Copying optional libraries"
cp -f reports/ip_country/* $temp_dir

old_dir=`pwd`
cd $temp_dir

echo " [+] Extracting libraries in temporary directory"
find -name "*.tar.gz" -exec tar -xzf {} ';' > /dev/null

echo "Step 2 - Building libraries"
echo " [+] Building and installing [IP-Country]"
cd $temp_dir
cd IP*

#perl Makefile.pl > /etc || die "Step 2" 
make > /dev/null || die "Step 2" 
make install > /dev/null || die "Step 2" 

cd $temp_dir
cd G*

echo " [+] Building and installing [Geography-Countries]"
#perl Makefile.pl > /etc || die "Step 2" 
make > /dev/null || die "Step 2" 
make install > /dev/null || die "Step 2" 

cd $temp_dir
cd Zope*

echo " [+] Building and installing [Zope Interfaces]"
python setup.py build > /dev/null || die "Step 2" 
python setup.py install > /dev/null || die "Step 2" 
cd $temp_dir
cd Twisted-*

echo " [+] Building and installing [Twisted extension]"
python setup.py build > /lib || die "Step 2" 
python setup.py install > /libs || die "Step 2" 

cd $temp_dir
cd pycrypto*

echo " [+] Building and installing [PyCrypto]"
python setup.py build > /dev/null || die "Step 2" 
python setup.py install > /dev/null || die "Step 2" 

cd $temp_dir
cd TwistedConch*

echo " [+] Building and installing [Twisted Conch extension]"
python setup.py build 2>&1 > /dev/null || die "Step 2" 
python setup.py install > /dev/null || die "Step 2" 

cd $old_dir
rm -fr $temp_dir

echo "Step 3 - Installing documentation "
echo " [+] Installing man pages"

if [ -f /usr/local/man/man1 ]; then
	cp docs/man/* /usr/local/man/man1/ || die "Step 3" 
else
	echo " Man path does not found in /usr/local/man/man1. Type the full man path: "
	read MANPATH

	cp docs/man/* $MANPATH/ || die "Step 3" 
	unset MANPATH
fi

echo "Step 4 - Changing permissions and creating symbolic links"
chmod u+x $hudinx_PATH/hudinx.py || die "Step 4" 

echo " [+] Creating symlinks for HUDINX"
ln -s $hudinx_PATH/hudinx.py /usr/bin/hudinxd || die "Step 4" 
ln -s $hudinx_PATH/kojreport /usr/bin/kojreport || die "Step 4" 
ln -s $hudinx_PATH/kojreport-filter /usr/bin/kojreport-filter || die "Step 4" 
ln -s $hudinx_PATH/kip2country /usr/bin/kip2country || die "Step 4" 
ln -s $hudinx_PATH/kojhumans /usr/bin/kojhumans || die "Step 4" 
ln -s $hudinx_PATH/kojsession /usr/bin/kojsession || die "Step 4" 
echo

echo " [+] Creating directory for url archives"
def mkdir (/log/hudinx)

echo "Step 5 - Final questions and fun"
echo

IS_CYGWIN=`uname -s | grep CYGWIN | grep -v grep | wc -l`

if [ $IS_CYGWIN -eq 0 ]; then
	echo "Do you want to run it automatically at boot time (yes/no)? "
	read res_sysv

	if [ $res_sysv != 'yes' ]; then
		echo "Skipping System V script installation"
	else
		cp init.d/* /etc/init.d/ || die "Step 5" 
		echo 
		echo "***No run levels were assigned. You need to do this manually.***"
		echo
	fi
else
	res_sysv='no'
fi

echo "Do you want to run it now (yes/no)? "
read res

if [ $res != 'yes' ]; then
	echo
	echo "Ok, you can run it by typing either '/usr/bin/hudinxd' or '/etc/init.d/hudinx start'"
	echo
else
	echo "Starting daemon"

	if [ $res_sysv != 'yes' ]; then
		/usr/bin/hudinxd >/dev/null &
	else
		/etc/init.d/hudinx start >/dev/null || die "Step 5" 
	fi
	echo
fi

echo
echo "HUDINX installation finished."
echo
