browser() {
  firefox&
}

communication() {
  discord&
  slack&
  thunderbird&
}

files() {
  seadrive -d $HOME/.seadrive/data -l $HOME/.seadrive/logs/seadrive.log -f $HOME/SeaDrive
  caja&
}

quicklaunch() {
  browser
  communication
  files
}

alias ql=quicklaunch
