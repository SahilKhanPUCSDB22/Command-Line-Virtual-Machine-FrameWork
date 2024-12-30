#
#check and install prerequistes

USER=$(whoami)
if [ $USER == "root" ];
then
	SUDO=""
else
	SUDO=sudo
fi

echo -e "Following packages are required to run the vm_manager :\n1.qemu-system\n2.virt-manager\n3.sed\n4.gawk\n5.grep\n6.coreutils"

echo "If installed enter y to procees else else n to exit"
read inp

if  [  $inp != 'y' ] && [ $inp != 'Y' ];
then
	echo "Exiting..."
	exit
fi


if [ ! -d "/home/$USER/vm_manager" ];
then
	echo "Creating vm_manager directory in home dir of user : $USER ..."
	mkdir -p /home/$USER/vm_manager/virt_disks
else
	if [ ! -d "/home/$USER/vm_manager/virt_disks" ];
	then
		"Creating virt_disks directory in vm_manager directory ..."
		mkdir /home/$USER/vm_manager/virt_disks
	fi
fi

echo "Moving all files to /home/$USER/vm_manager/ ..."

mv vm* /home/$USER/vm_manager/ 

if [ $? -ne 0 ];
then
	echo "Failed to move files to /home/$USER/vm_manager ..."
	echo "Retry..." 
	exit
fi
echo -e "Add this line in your local bash conf file to use aliases:\nsource /home/$USER/vm_manager/vmrc"

echo "Check readme for detailed description of aliases and their uses."

echo "Setup done."
