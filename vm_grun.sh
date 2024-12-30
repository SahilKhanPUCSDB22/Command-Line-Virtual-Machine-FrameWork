#
#opens graphical console for a virtual machine

#
#check number of arguments
if [ $# -ne 1 ];
then
	echo "usage: vm-grap-run vmname"
	exit
fi

#
#check if machine exists or not
if [ -z "$(virsh list --all | grep "$1")" ];
then
	echo "Machine: $1 does not exist!!! Try creating one using vm-create."
	exit
fi

#
#check if machine is running
if [ -z "$(virsh list --all | grep "$1" | grep "running")" ];
then
	echo "Starting Machine"
	
	virsh start $1
	if [ $? -ne 0 ];
	then
		echo 'Failed to Start Machine.Try again'
		exit
	fi
fi

#
#start display console using virt-viewer
virt-viewer --wait --reconnect  "$1" &>/dev/null

if [ $? -ne 0 ];
then
	echo "Failed to open display for Machine"
fi
