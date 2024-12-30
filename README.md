A simple virtual machine creation and management interface based on virsh command line utility.Currently in it's primitive stage.
Entirely written using bash script.
Allows to create , run, ssh into, clone, list and destroy virtual machines easily.

List of aliases :
1. vm-create -> no args -> used to create virtual machine ->requires iso file of the desired operating system.
2. vm-destroy -> name of vm -> removes the virtual machine
3. vm-clone -> no args -> clones requested virtual machine
4. vm-list -> no args -> lists all virtual machines
5. vm-ssh-run -> name of vm - username to log into on vm -> run and ssh into the machine if ssh is enabled by the user
6. vm-grap-run -> name of vm -> run and open a graphical console for a machine
7. vm-stop -> name of vm -> stops a running virtual machine(if unsuccessfull force terminate the virtial machine)

Platforms supported currently : ubuntu
Testing on other platforms is not done yet.Will update this as further testing is done.

Any future aliases or changes will be updated here.Thank you.
