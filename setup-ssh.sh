read -p "Enter user:server: " sshcommand
read -p "Do you want to generate ssh-keygen? (y/n) " yn

case $yn in 
	[yY] ) echo OK, we will generate a new key;
        ssh-keygen;
		break;;
	* )  
esac
ssh-copy-id $sshcommand
