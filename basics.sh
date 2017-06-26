sudo apt-get update

echo "Setting up dotfile links..."
backup() {
  target=$1
  if [ ! -L "$target" ]; then
    mv "$target" "$target.backup"
    echo "------> Backup'd $target config file to $target.backup"
  else
    rm "$target"
  fi
}

link() {
  name=$1
  target="$HOME/.$name"
  if [ -e "$target" ]; then
  	backup $target
  fi

  if [ ! -e "$target" ]; then
    echo "------> Linking $name at $target"
    ln -s "$PWD/$name" "$target"
  else
    echo "Error! Linking failed because file already exists and couldn't be backup'd!" 1>&2
    exit 2
  fi
}

cd dot
for name in *; do
  link $name
done
cd ..

echo "Configuring Git..."
sudo apt-get install -y git
echo "Full name: "
read full_name
echo "Email address: "
read email

git config --global user.name  $full_name
git config --global user.email $email

echo "Installing Oh-my-zsh..."
sudo apt-get install -y zsh curl vim nodejs imagemagick jq
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh > install.sh && bash install.sh && rm install.sh

zsh setup_config.sh
