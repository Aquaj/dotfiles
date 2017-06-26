echo "Fetching & Deploying SSH..."
mkdir -p ~/.ssh && cp ssh/id_rsa.pub ~/.ssh/
echo "Private key distant url: "
read ssh_url
scp "$ssh_url" ~/.ssh/id_rsa
chmod 600  ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa

echo "Fetching & Deploying GPG..."
mkdir -p ~/.gnupg && cp gnupg/public.key ~/.gnupg
echo "Private key distant url: "
read gpg_url
scp "$gpg_url" ~/.gnupg/private.key
gpg --import ~/.gnupg/private.key

echo "Testing..."
ssh -T git@github.com && echo "Success !" || echo "SSH setup unsuccessful !"

echo "Installing Ruby..."
echo "  - Installing RBENV..."
rvm implode && sudo rm -rf ~/.rvm || true
rm -rf ~/.rbenv
sudo apt-get install -y autoconf bison build-essential libssl1.0-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo apt-get clean

RBENV_PATH="/usr/local/opt/"
RUBY_BUILD_PATH="$RBENV_PATH/plugins/ruby-build"
sudo mkdir -p "$RBENV_PATH" && sudo chown `whoami`:`whoami` $_

git clone https://github.com/rbenv/rbenv.git "$RBENV_PATH/rbenv"
git clone https://github.com/rbenv/ruby-build.git "$RUBY_BUILD_PATH"
sudo rm -f /usr/bin/rbenv
sudo ln -s "$RBENV_PATH/rbenv/libexec/rbenv" /usr/bin/rbenv
sudo chmod +x "$RUBY_BUILD_PATH/install.sh"
sudo "$RUBY_BUILD_PATH/install.sh"

echo "Ruby version to install?"
read ruby_version

rbenv install "$ruby_version"
rbenv global "$ruby_version"

echo "Postgresql installation..."
sudo apt-get install -y postgresql postgresql-contrib libpq-dev build-essential
echo `whoami` > /tmp/caller
stty -echo
echo "DB User password: "
read password
echo "'$password'" > /tmp/password
stty echo
sudo runuser -l postgres -c 'psql --command "DROP ROLE IF EXISTS `cat /tmp/caller`;"'
sudo runuser -l postgres -c 'psql --command "CREATE ROLE `cat /tmp/caller` LOGIN SUPERUSER PASSWORD `cat /tmp/password`;"'
rm -f /tmp/caller
rm -f /tmp/password

echo "Installing tmux..."
sudo apt-get install -y tmux
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing Todo.sh"
curl -L https://github.com/downloads/ginatrapani/todo.txt-cli/todo.txt_cli-2.9.zip > /tmp/todo.sh.zip
unzip /tmp/todo.sh.zip -d /tmp/
sudo mv /tmp/todo.txt_cli-2.9 /tmp/todo
sudo cp /tmp/todo/todo.sh /usr/bin/todo.sh
sudo chmod +x /usr/bin/todo.sh
sudo rm -f /etc/todo/config
sudo mkdir /etc/todo
sudo ln -s dot/todo/config /etc/todo/config
rm -rf /tmp/todo*

echo "Done !"
