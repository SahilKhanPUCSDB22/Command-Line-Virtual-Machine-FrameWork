echo -e "\nVM stopper running.\n"

#
#check no of arguments
if [ $# -ne 1 ];
then
	echo "Usage: vm-stop vm_name"
	exit
fi

#
#Check if machine exists or not

if [ -z "$(virsh list --all | grep "$1")" ];
then
	printf "Machine : $1 does not exist!!!\nCheck below and try again.\n\n"
	virsh list --all
	exit
else
	#
	#Check if machine is running or not
	if [ -z "$(virsh list --all | grep "$1" | grep "running")" ];
	then
		echo "Machine :$1 is not running!!!"
		exit
	else
		echo "Shutting Down Machine : $1"
		virsh shutdown "$1" &>/dev/null
		if [ $? -ne 0 ];
		then
			printf "Shutdown Failed.Forcing machine termination.\n"
			virsh destroy "$1"
		fi

	fi
fi
