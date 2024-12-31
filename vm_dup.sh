USER=$(whoami)
VMDIR=vm_manager
DISKDIR=virt_disks
WORKDIR=/home/$USER/$VMDIR/$DISKDIR/

echo "Select the machine to clone :"
MACHINES=$(virsh list --all | grep '^\s[0-9-]')
LIST=$(echo "$MACHINES" | awk '{print $2}')
COUNT=$(echo "$LIST" | wc -l)

ALLMACHINES="$(paste <(seq 1 $COUNT) <(echo "$LIST"))"

echo "$ALLMACHINES"
printf "Enter option number :"
read OPTION

if ! [[ $OPTION =~ ^-?[0-9]+$ ]];
then
	echo "Invalid input.Expected integer"
	exit
fi

if [ $OPTION -le 0 ] || [ $OPTION -gt $COUNT ] ;
then
	echo "Invalid input"
	exit
fi

SRCMACHINE=$(echo "$LIST" | sed -n $OPTION'p')
echo "You selected : $SRCMACHINE"

if [ ! -z "$(echo $MACHINES | grep $SRCMACHINE | grep "running")" ];
then
	echo "Machine is running.Shutdown before cloning"
	exit
fi

printf "Enter new machine name :"
read DESTMACHINE

echo "Starting Cloning process..."
virt-clone \
	--original $SRCMACHINE \
	--name $DESTMACHINE \
	--file $WORKDIR/$DESTMACHINE.qcow2

if [ $? -ne 0 ];
then
	echo "Failed to clone machine.Try again..."
else
	echo -e "Machine clone successfully(Password : 1234t).\nTo reconfigure the machine:\nRename-hostname -> Change machine id"
fi
