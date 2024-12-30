#
#check and install prerequistes

USER=$(whoami)
if [ $USER == "root" ];
then
	SUDO=""
else
	SUDO=sudo
fi

echo -e "Following packages are required to run the vm_manager :\n1.qemu-system\n2.virt-manager\n3.sed\n4.gawk\n5.grep\n6.coreutils\n\nAn attempt will be made to install these packages..."

$SUDO apt install -y qemu-system virt-manager sed gawk grep coreutils

echo "If all installed enter y to proceed else else n to exit"
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

if [ -z "$(cat /home/$USER/.bashrc | grep "source /home/$USER/vm_manager/vmrc")" ];
then
	echo "source /home/$USER/vm_manager/vmrc" >> /home/$USER/.bashrc
	echo "Adding source statement to .bashrc for aliases"
fi

PRESWD=$pwd
cd /home/$USER/
rm -rf $PRESWD

source /home/$USER/.bashrc

echo "Check readme for detailed description of aliases and their uses."

echo "ALL Setup Done."
