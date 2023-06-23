# -*- mode: ruby -*-
# vi: set ft=ruby :

#
#	Ubuntu Jammy 64-bit Linux mit Docker
#

## hallo

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"

  # Create forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. 
  # NOTE: This will enable public access to the opened ports
  config.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true
  config.vm.network "forwarded_port", guest:8081, host:8081, auto_correct: true
  config.vm.network "forwarded_port", guest:8082, host:8082, auto_correct: true
  config.vm.network "forwarded_port", guest:8083, host:8083, auto_correct: true
  config.vm.network "forwarded_port", guest:3306, host:3306, auto_correct: true  
 
  # forward a bunch of ports
  for i in 32760..32780
    config.vm.network :forwarded_port, guest: i, host: i
  end
    
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.hostname = "docker"
  # Share an additional folder to the guest VM.
  config.vm.synced_folder ".", "/mnt"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end
  
  config.vm.provision "shell", inline: <<-SHELL
  #Get Docker Image
  sudo apt-get update
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
	
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  #Install Docker
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  
  # fix vim issue beim pasten (https://vi.stackexchange.com/questions/5310/how-can-i-stop-vim-automatically-inserting-a-tab-in-css-files)
  echo "let skip_defaults_vim=1" >> /etc/vim/vimrc

  SHELL

  # add ssh public keys for root and vagrant 
  config.vm.provision "shell", path: "scripts/add_ssh_pub.sh"
  # add alias
  config.vm.provision "shell", path: "scripts/add_alias.sh"
  
end


