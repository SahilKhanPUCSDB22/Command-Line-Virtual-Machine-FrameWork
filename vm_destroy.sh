USER=$(whoami)
VMDIR=vm_manager
echo -e "\nVM Destroyer running...\n"

#
#check params
#
if [ $# -ne 1 ];
then
	echo -e "\nUsage: vm-destroy vm_name\n"
	exit
fi

#
#check machine 
#
if [ -z $(virsh list --all | grep "$1") ];
then
	echo "No such machine exists..."
	exit
fi

#
#remove qcow2 file
#
echo "Removing qcow file..."
find /home/$USER/$VMDIR/ -type f -name "$1*" -exec rm {} +
if [ $? -ne 0 ];
then
	echo "No qcow file found for the machine.Proceeding with machine removal..."
else
	echo "Removed. Proceeding with machine removal..."
fi

if [ ! -z "$(virsh list | grep "$1")" ];
then
	echo -e "\nVM already running.Killing....\n"
	virsh destroy $1
fi
sleep 1

echo -e "\nUndefining domain\n"
virsh undefine --domain $1
if [ $? -ne 0 ];
then
	echo -e "Failed to Undefine domain!!! Try again or use virt-manager.\n"
else
	echo -e "VM : $1 destroyed Successfully.\n"
fi

echo "Done..."
