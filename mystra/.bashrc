# .bashrc

# Bash options
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Quake-like terminals
# . $HOME/scripts/yaql.sh 90 20
# source ~/.yaql.bashrc

complete -cf sudo
source ~/.git-completion.bash


# set history variables 
export HISTFILESIZE="3000"
export HISTCONTROL="ignoredups"

# share history across all terminals
shopt -s histappend
PROMPT_COMMAND='history -a'



# Aliases
#alias ls='ls -AFhs --color'
alias calc='sh /home/kittykatt/scripts/Old\ Scripts/shellcalc.sh'
# Custom, funny startx alias
alias engage='startx'
# Local MPD/mpc
alias mpc-local='mpc --host=localhost'
# Start up wireless and wireless menu
alias wirelessgo='sudo ifconfig eth0 down && sudo ifconfig wlan0 up && sudo netcfg-menu'
# alias conkystart='sh /home/kittykatt/.conky/NightDrive/start_conky.sh'
alias recent='find -maxdepth 1 -type f -mtime -1 -printf "%T@-%Tk:%TM - %f\n" | sort -rn | cut -d- -f2-'
alias ls='ls -Fhs --color --group-directories-first'
alias ll='ls -asl --color'
alias cp='cp -i'
alias mv='mv -i'
alias edit='nano -w'
alias pg='ps aux | grep -i'
alias duh='du -h --max-depth=1'
alias fm='fmio -d gtp'
alias grep='grep --color=auto'
alias yogurt='yaourt'
alias coolshit="echo 'ice + dog + laxatives = cool shit'"
alias xchat="myxchat &"
# Show outdated packages and current version of packages
#alias outdatedpkgs="for pkg in $(pacman -Quq); do; echo $(pacman -Q $pkg) $(sudo pacman -Sdp --print-format "=> %v" $pkg); done"


# Fun aliases
# alias bofh="telnet towel.blinkenlights.nl 666"
# alias clifu1="curl -sL 'www.commandlinefu.com/commands/random' | awk -F'</?[^>]+>' '/"command"/{print $2}'"
# alias newgmail="curl -u zeldarealm --silent "https://mail.google.com/mail/feed/atom" | perl -ne 'print "\t" if /<name>/; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'"
# alias videoplz="ffmpeg -f x11grab -s `xdpyinfo | grep 'dimensions:'|awk '{print $2}'` -r 25 -i :0.0 -sameq /tmp/out.mpg > /root/howto/capture_screen_video_ffmpeg"
# alias shadyurl=`SITE="www.google.com"; curl --silent "http://www.shadyurl.com/create.php?myUrl=$SITE&shorten=on" | awk -F\' '/is now/{print $6}'`
# alias archivenow="tar -cf - . | pv -s $(du -sb . | awk '{print $1}') | gzip > out.tgz"


# Pacman Aliases
# Lets you search through all available packages simply using 'pacsearch packagename'
alias pacsearch="pacman -Sl | cut -d' ' -f2 | grep "
# coloured repo search
search () {
       echo -e "$(pacman -Ss $@ | sed \
       -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
       -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
       -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
       -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}

####### Functions ########
##########################

# Extract Files
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}

# Find character length of string

strlen() { echo -n ${#1}; }

# Follow copied and moved files to destination directory

goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

cpf() { cp "$@" && goto "$_"; }

mvf() { mv "$@" && goto "$_"; }





# Colors
Black="$(tput setaf 0)"
BlackBG="$(tput setab 0)"
DarkGrey="$(tput bold ; tput setaf 0)"
LightGrey="$(tput setaf 7)"
ightGreyBG="$(tput setab 7)"
White="$(tput bold ; tput setaf 7)"
Red="$(tput setaf 1)"
RedBG="$(tput setab 1)"
LightRed="$(tput bold ; tput setaf 1)"
Green="$(tput setaf 2)"
GreenBG="$(tput setab 2)"
LightGreen="$(tput bold ; tput setaf 2)"
Brown="$(tput setaf 3)"
BrownBG="$(tput setab 3)"
Yellow="$(tput bold ; tput setaf 3)"
Blue="$(tput setaf 4)"
BlueBG="$(tput setab 4)"
LightBlue="$(tput bold ; tput setaf 4)"
Purple="$(tput setaf 5)"
PurpleBG="$(tput setab 5)"
Pink="$(tput bold ; tput setaf 5)"
Cyan="$(tput setaf 6)"
CyanBG="$(tput setab 6)"
LightCyan="$(tput bold ; tput setaf 6)"
NC="$(tput sgr0)"       # No Color

export BROWSER=chromium
export SCREENSERVE="$HOME/sshfs/archserver-served/served/screens"
export MPD_HOST="lloth"
export MPD_PORT="6600"

# Set prompt colour
if [ `id -u` -eq 0 ]
then
    cText="${LightRed}"
else
    cText="${LightBlue}"
fi


export GIT_PS1_SHOWDIRTYSTATE=1

function find_git_branch {
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(< "$dir/.git/HEAD")
            if [[ $head == ref:\ refs/heads/* ]]; then
                git_branch=" ${head#*/*/}"
            elif [[ $head != '' ]]; then
                git_branch=' (detached)'
            else
                git_branch=' (unknown)'
            fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
}

PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"

# Fancy bash
PS1='\[$White\]\[$cText\][\[$White\]\u\[$cText\]@\[$White\]\h\[$cText\]][\[$White\]\w\[$LightGreen\]$(__git_ps1)\[$cText\]]\$\[$NC\] '
