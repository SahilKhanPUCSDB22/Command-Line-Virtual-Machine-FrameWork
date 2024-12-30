USER=$(whoami)
DISK_LOCATION=/home/$USER/vm_manager/virt_disks

if [ $# -ne 0 ];
then
	echo "No arguments required!!!"
fi

ls $DISK_LOCATION | cut -d'.' -f1

