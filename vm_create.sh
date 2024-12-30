cpu=2

printf "\nScript to create Virtual Machines using virsh.\n\
\nBy default the number of CPU cores assigned to each VM is $cpu\n\
Arguments:\n\
		1. Name of VM (you can choose whatever you like avoiding duplicate\n\
		2. Ram in megabytes required for VM ( >= 1500 to avoid lagging )\n\
		3. Size in gigabytes of virtual disk(vda/hd) ( Optimal > 10GB )\n\
		4. Iso file of the desired operating system\n\
\nDo you want to procees(y/n) :"
read proceed
if [ $proceed == 'n' ];
then
	exit
fi

printf "\nEnter VM Name: "
read name

printf "\nEnter Ram Size(in M): "
read ram
while [ $ram -lt 1500 ];
do
	printf "\nEnter 1500 or greater : "
	read ram
done

printf "\nEnter Disk Size(in G): "
read vdsize
while [ $vdsize -lt 10 ];
do
	printf "\nEnter 10 or greater: "
	read vdsize
done

printf "\nEnter Iso File Name: "
read -e isofile

/home/$(whoami)/vm_manager/vm_init.sh $name $ram $vdsize $isofile
