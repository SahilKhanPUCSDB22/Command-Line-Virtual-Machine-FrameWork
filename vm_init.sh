VMNAME=$1
VMRAM=$2
VMSIZE=$3
VMISOFILE=$4

USER=$(whoami)
VMDIR=vm_manager
DISKDIR=virt_disks
SILENCE="/dev/null"
ARGS=4
NCPU=2
QCOW2POOL="/home/$USER/$VMDIR/$DISKDIR"

#
#usage error
if [ $# -ne $ARGS ]; 
then
	echo -e "\nUsage : vm-create name_of_vm ram_required disk_size_required iso_file\n"
	exit
fi

#
#check if directory present
if [ ! -d "/home/$USER/$VMDIR" ];
then
	mkdir -p /home/$USER/$VMDIR/$DISKDIR/
else
	if [ ! -d "/home/$USER/$VMDIR/$DISKDIR" ];
	then
		mkdir /home/$USER/$VMDIR/$DISKDIR
	fi
fi

#
#check if vm_present
if [ -n "$( virsh list --all| grep $VMNAME )" ];
then
	printf "\nVM of same name exists.Want to remove it(y/n)? "
	read delete
	if [ '$delete' == 'n' ]; then
		exit
	else
		if [ ! -z "$(virsh list --all | grep "$VMNAME")" ];
		then
			echo "Force Shutting Down VM"
			virsh destroy $VMNAME
		fi
		sleep 2
		virsh undefine --domain $VMNAME
	fi
fi

#
#if qcow already present

if [ -f "$QCOW2POOL/$VMNAME.qcow2" ];
then
	echo -e "\nRemoving existing qcow2 file"
	rm $QCOW2POOL/$VMNAME.qcow2
fi
echo -e "Attempting to create a new qcow file\n"
qemu-img create -f qcow2 /home/$USER/$VMDIR/$DISKDIR/$VMNAME.qcow2 "$VMSIZE"G &> $SILENCE

err_status=$?

if [ $err_status -ne 0 ];
then
	if [ -f $VMNAME.qcow2 ];
	then
		rm $VMNAME.qcow2
	fi
	exit
fi

#
#replace placeholders

QCOWP="/home/$USER/$VMDIR/$DISKDIR/$VMNAME.qcow2"
#ison="/home/$USER/$VMDIR/$VMISOFILE"

echo -e "******First run of VM********\n"

virt-install \
  --name $VMNAME \
  --ram 2500 \
  --vcpus 4 \
  --disk path=$QCOWP,format=qcow2 \
  --cdrom $VMISOFILE \
  --osinfo detect=on,require=off


if [ $? -ne 0 ];
then
	echo "Virt Install : failed to run installer"
	exit
fi

virsh setmem $VMNAME "$VMRAM"M --config
if [ $? -ne 0 ];
then 
	echo -e "Failed to virsh set memory(ram) size of VM.Change it manually using virt-manager."
	exit
else
	echo -e "Ram set to user input."
fi

virsh setvcpus $VMNAME $NCPU --config
if [ $? -ne 0 ];
then 
	echo -e "Failed to virsh set cpu count(cores) of VM.Change it manually using virt-manager.\n"
	exit
else
	echo -e "cpus set to user input"
fi

echo "Virtual Machine created Successfully..."
