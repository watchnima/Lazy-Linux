#!/bin/bash
# Author: zouxu

. ./log.sh

# macros
ll_install='sudo apt-get -y install'

# head
ll_print_head

# update & upgrade
ll_print_term "Update and upgrade"

echo "Replace source \"http://cn.archive.ubuntu.com/ubuntu/\""
while true; do
  echo "1. press <enter>  set default \"https://mirrors.aliyun.com/ubuntu/\""
  echo "2. press <s>      set new"
  echo "3. press <n>      do nothing"
  read isSet
  if [ -z ${isSet} ]; then
    sudo sed -i s\#http://cn.archive.ubuntu.com/ubuntu/\#https://mirrors.aliyun.com/ubuntu/\#g /etc/apt/sources.list
    break
  elif [ ${isSet}x == 's'x ]; then
    read -p "new source:" ArchiveUbuntu
    sudo sed -i s\#http://cn.archive.ubuntu.com/ubuntu/\#${ArchiveUbuntu}\#g /etc/apt/sources.list
    break
  elif [ ${isSet}x == 'n'x ]; then
    break
  else
    ll_print_error "invalid input"
    continue 
  fi
done

echo "Replace source \"http://security.ubuntu.com/ubuntu/\""
while true; do
  echo "1. press <enter>  set default \"https://mirrors.aliyun.com/ubuntu/\""
  echo "2. press <s>      set new"
  echo "3. press <n>      do nothing"
  read isSet
  if [ -z ${isSet} ]; then
    sudo sed -i s\#http://security.ubuntu.com/ubuntu\#https://mirrors.aliyun.com/ubuntu/\#g /etc/apt/sources.list
    break
  elif [ ${isSet}x == 's'x ]; then
    read -p "new source:" SecurityUbuntu
    sudo sed -i s\#http://security.ubuntu.com/ubuntu\#${SecurityUbuntu}\#g /etc/apt/sources.list
    break
  elif [ ${isSet}x == 'n'x ]; then
    break
  else
    ll_print_error "invalid input"
    continue 
  fi
done

sudo apt-get update
sudo apt-get upgrade

# common tools
ll_print_term "install aptitude curl cloc tree cmake net-tools python2/3 pip2/3"
${ll_install} aptitude curl cloc tree cmake net-tools
${ll_install} python2 python3
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python2 get-pip.py
sudo python3 get-pip.py
rm get-pip.py

# libraries
ll_print_term "install libraries: gcc-multilab,g++-multilib libsdl2-dev"
${ll_install} gcc-multilib g++-multilib   # 64-bits platform 32-bits program cross-compiling libraries
${ll_install} libsdl2-dev # support QEMU sdl

# vim/git/typora
ll_print_term "install vim neovim tig git"
${ll_install} vim neovim tig git
sudo wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
${ll_install} typora

# shell tools zsh/oh-my-zsh/autojump
ll_print_term "install zsh"
${ll_install} zsh

ll_print_term "install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ll_print_term "configure zsh"
echo "\n# configured by Lazy linux\n" >> ~/.zshrc
cat ./zsh.conf >> ~/.zshrc

ll_print_term "install autojump"
${ll_install} autojump
echo "source /usr/share/autojump/autojump.zsh" >> ~/.zshrc
echo "autoload -U compinit && compinit\n" >> ~/.zshrc

# spacevim
ll_print_term "install spacevim"
git clone https://github.com.cnpmjs.org/SpaceVim/SpaceVim ~/.Spacevim
curl -sLf https://spacevim.org/install.sh | bash

ll_print_term "build spacevim environment"
${ll_install} gem
${ll_install} ruby ruby-dev
${ll_install} build-essential
sudo gem install neovim
sudo gem update msgpack
${ll_install} nodejs
${ll_install} npm
sudo npm install -g neovim
sudo pip2 install --upgrade neovim
sudo pip2 install --user --upgrade neovim
sudo pip2 install --upgrade pynvim
sudo pip2 install --user --upgrade pynvim
sudo pip2 install --upgrade msgpack
sudo pip3 install --upgrade neovim
sudo pip3 install --user --upgrade neovim
sudo pip3 install --upgrade pynvim
sudo pip3 install --user --upgrade pynvim
sudo pip3 install --upgrade msgpack
cp -rf ./.SpaceVim.d ~/.SpaceVim.d

ll_print_term "install powerline fonts"
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts
ll_print_message "please set terminal font to xxxpowerline"

# deepin tools
read -p "install deepin tools(Y/n):" ifdeepin
if [ ${ifdeepin}x == 'y'x ]||[ ${ifdeepin}x == 'Y'x ]; then
  ll_print_term "install deepin-terminal deepin-screenshot"
  ${ll_install} deepin-terminal
  sudo mv /usr/bin/deepin-terminal /usr/bin/gnome-terminal
  ${ll_install} deepin-screenshot
fi

# sougou input method
read -p "install sougou input method(Y/n):" sougou
if [ ${sougou}x == 'y'x ]||[ ${sougou}x == 'Y'x ]; then
  ll_print_term "install fcitx"
  sudo apt-get --fix-broken -y install
  ${ll_install} fcitx-bin
  ${ll_install} fcitx-table
  
  sougouDeb="sogoupinyin_2.3.2.07_amd64-831.deb"
  ll_print_term "install ${sougouDeb}"
  if [ ! -f ${sougouDeb} ]; then
    url="http://cdn2.ime.sogou.com/dl/index/1599192613/${sougouDeb}?st=sfJbMK7gsnHe7lKbeyCUzw&e=1600700152&fn=${sougouDeb}"
    curl ${url} -o ${sougouDeb}
  fi
  if [ ! -f ${sougouDeb} ]; then
    ll_print_error "Download ${sougouDeb} failed! (Sogoupinyin version is too old or internet is not connected)"
  else
    sudo dpkg -i ${sougouDeb}
    rm ${sougouDeb}
    ll_print_message "1. Add sogoupinyin input method in fcitxConfiguration. \n2. Install chinese language package in Language Support"
  fi
fi

# reboot
read -p "reboot now(Y/n):" ifreboot
if [ ${ifreboot}x == 'y'x ]||[ ${ifreboot}x == 'Y'x ]; then
  reboot
fi
