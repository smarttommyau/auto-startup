echo "install ALL require packages"
packagesNeeded='curl wget git gh neovim fzf zsh dos2unix lolcat figlet cowsay gpg'
if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then sudo apt-get install $packagesNeeded
elif [ -x "$(command -v dnf)" ];     then sudo dnf install $packagesNeeded
elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; fi

# Setup ZSH
echo "setup oh-my-zshzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Setup font
echo "setup font"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/ProFont.zip
mkdir ~/.local/share/fonts
unzip ProFont.zip ~/.local/share/fonts/
rm ProFont.zip
fc-cache -fv
# Setup p10k
echo "setup p10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/' ~/.zshrc
# install plugins
echo "setup rest of plugins"
## zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
## zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
## fast-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
## fzf-tab
git clone https://github.com/Aloxaf/fzf-tab \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab


## prevent any format problems
find ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions -type f -print0 | xargs -0 -n 1 -P 4 dos2unix
find ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting -type f -print0 | xargs -0 -n 1 -P 4 dos2unix

find ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting -type f -print0 | xargs -0 -n 1 -P 4 dos2unix
find ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab -type f -print0 | xargs -0 -n 1 -P 4 dos2unix

## replace plugins
sed -i "s/(git)/(git sudo z zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting fzf-tab)/" ~/.zshrc
## welcome messgae
sed -i '1 i\figlet "WELCOME BACK TOMMY" | lolcat -f' ~/.zshrc
sed -i '2 i\fortune | cowsay | lolcat -f' ~/.zshrc


# setup nvim
echo "setup neovim"
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone https://github.com/smarttommyau/astrovim_custom_new ~/.config/nvim/lua/user
nvim
echo "setup git credentials"
git config --global core.autocrlf true
gh auth login
gh auth setup-git
echo "setup gpgkey"
gpg --full-generate-key
gpg --armor --export "$(gpg --list-secret-keys --keyid-format=long | sed -n 's/.*\(sec\s\s\s.*\).*/\1/p' | sed -n 's/.*\(\/[[:alnum:]]*\).*/\1/p' | sed -n -e 's/\///p'
)" > gpgresult
gh gpg-key add gpgresult
rm gpgresult
echo "Finished setup"
