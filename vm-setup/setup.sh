# https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services
# https://www.faqforge.com/linux/fixed-ubuntu-apt-get-upgrade-auto-restart-services/
export DEBIAN_FRONTEND=noninteractive
sudo echo "\$nrconf{restart} = 'a'" >> /etc/needrestart/needrestart.conf

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y && \
  sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y && \
  sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip mc pipx git wget
pip install --upgrade pip

# Check if there's a video card with H100 model (2330 GH100 [H100 SXM5 80GB]
if lspci -nnk | grep -q "[10de:2330]"; then
  # If yes, install the necessary kernel package
  sudo apt install -y linux-generic-hwe-22.04
fi

# Install Ubuntu drivers common package
sudo DEBIAN_FRONTEND=noninteractive apt install ubuntu-drivers-common -y

recommended_driver=$(ubuntu-drivers devices | grep 'nvidia' | cut -d ',' -f 1 | grep 'recommended')
package_name=$(echo $recommended_driver | awk '{print $3}')
sudo DEBIAN_FRONTEND=noninteractive apt install $package_name -y

sudo reboot

# ##############

pipx ensurepath
pipx install nvitop

# Docker Install
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker
# sudo systemctl status docker

# create the docker group and add your user
sudo groupadd docker
sudo usermod -aG docker ${USER}

# activate the changes to groups
newgrp docker

  
# Setting up NVIDIA Container Toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.4.1-runtime-ubuntu22.04 nvidia-smi

# for git
git config --global user.email "alexeigor@gmail.com"
git config --global user.name "Alexey Gorodilov"

# iTerm2
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

# vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_basic_vimrc.sh