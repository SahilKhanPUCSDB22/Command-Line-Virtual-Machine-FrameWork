#
#check the number of arguments
if [ $# -ne 2 ]; then
	echo "Usage: vm-ssh-run vmname username_on_vm"
	exit 1
fi

#
#fixe number of attempts
tries=5
echo -e "\nVM ssh-runner starting.\nMaximum of $tries ping attempts will be made for every VM.\n"
sleep 1

#
#check if machine exists or not

if [ -z "$(virsh list --all | grep "$1")" ];
then
	echo "Machine : $1 does not exist.Check name from below and retry."
	virsh list --all
	exit
fi

#
#Check if VM is already running
if [ -z "$(virsh list --all | grep "$1" | grep "running")" ]; then 
	echo "Starting Machine : $1 ..."
	(virsh start $1&) 1>/dev/null
	if [ $? -ne 0 ];
	then
		echo "Failed to start Machine"
		exit
	fi
	echo "Machine is UP"
else
	echo "Machine :$1 is already running!!!"
fi

#
#try pinging the machine
while [ $tries -ne 0 ]; do
	#get ip address of the machine
	ip_addr=$(virsh domifaddr --domain "$1" | tail -2 | awk '{print $4}'| cut -d'/' -f 1 |head -1)

	ping -c 4 "$ip_addr" 1>/dev/null 
	if [ $? -ne 0 ]; 
	then
		echo "$1 is reachable.Attempting SSH connection...."
		ssh -4 "$2@$ip_addr" -o ConnectTimeout=5
		if [ $? -ne 0 ];
		then
			echo "SSH failed..."
			((tries--))
		else
			echo "Exiting..."
			tries=0
		fi
	else
		exit_code=$?
		echo "Ping Failed(code $exit_code).Retrying($tries)..."
		((tries--))
		if [ $tries -eq 0 ];
		then
			echo -e "\nFailed to Connect to vm.Try checking the ssh server configuration of the remote machine and try again."
		fi
	fi
done
