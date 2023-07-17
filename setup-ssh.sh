read -p "Enter user:server: " sshcommand
ssh-keygen
ssh-copy-id $sshcommand
