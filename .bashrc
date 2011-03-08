# {{{ Prompt
setprompt(){
	# Capture last return code
	local rts=$?

	# Get path with tilde for home
	if [[ "$PWD" == "$HOME" ]]; then
	local dir="~"
	elif [[ "${PWD:0:${#HOME}}" == "$HOME" ]]; then
	local dir="~${PWD:${#HOME}}"
	else
	local dir=$PWD
	fi

	# Truncate path if it's long
	if [[ ${#dir} -gt 19 ]]; then
	local offset=$((${#dir}-18))
	dir="+${dir:$offset:18}"
	fi

	# Path color indicates host
#	case "$HOSTNAME" in
#	"TUD276400") local dircol="\[\e[1;35m\]"; ;; # Desktop
#	"") local dircol="\[\e[1;32m\]"; ;; # Laptop
#	"") local dircol="\[\e[1;31m\]"; ;; # Server
#	*) local dircol="\[\e[1;37m\]"; ;; # Other
#	esac

	# Marker char indicates root or user
	[[ $UID -eq 0 ]] && local marker='#' || local marker='$'

	# Marker color indicates successful execution
	[[ $rts -eq 0 ]] && local colormarker="\[\e[1;37m\]$marker" \
	|| local colormarker="\[\e[1;31m\]$marker"

	# Set PS1
	PS1="${dircol}${dir} ${colormarker}\[\e[0;37m\] "

	# Append history to saved file
	history -a
}
PROMPT_COMMAND="setprompt &> /dev/null"

# Applications
export EDITOR='vim'

# Check for current bash version
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
	shopt -s autocd cdspell
	shopt -s dirspell globstar
fi

# General options
shopt -s cmdhist nocaseglob
shopt -s histappend extglob


# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
mesg y

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto -Fh --group-directories-first'
		alias ll='ls -alh'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# Directory up
#..() { cd "../$@"; }
#..2() { cd "../../$@"; }
#..3() { cd "../../../$@"; }
#..4() { cd "../../../../$@"; }
#..5() { cd "../../../../../$@"; }
#
# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias l='ls'
alias v='vim'
alias vv='sudo vim'

cd(){
    if [ -d "$1" ]; then
        builtin cd "$1"
        ls
		else
			builtin cd
			ls
    fi
}

# Complete only directories on cd
complete -d cd

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
source /etc/profile

# xmodmap
if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

# vi editing mode
set -o vi

bind '"\C-i":complete'

diffdir(){
	if [ ! -d "$1" ]
	then
		echo "Directory $1 does not exist!"
		return 1
	fi

	for file in `ls`;
	do
		echo "---- $file ----"
		if [ -f "$1$file" ]
		then
			if [ $# -eq 2 ]
			then
				diff $file $1$file > /dev/null
				if [ $? -ne 0 ]
				then
					$2 $file $1$file
					read -p "Press any key to continue.."
				fi
			else
				diff -a -c $file $1$file
			fi
		else
			echo "File not in target dir"
		fi
	done

}

~/.startfirefox


#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.

#This shell snippet sets the prompt command and the necessary aliases
_autojump() 
{
        local cur
        cur=${COMP_WORDS[*]:1}
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done  < <(autojump --bash --completion $cur)
}
complete -F _autojump j
#data_dir=${XDG_DATA_HOME:-$([ -e ~/.local/share ] && echo ~/.local/share || echo ~)}
data_dir=$([ -e ~/.local/share ] && echo ~/.local/share || echo ~)
export AUTOJUMP_HOME=${HOME}
if [[ "$data_dir" = "${HOME}" ]]
then
    export AUTOJUMP_DATA_DIR=${data_dir}
else
    export AUTOJUMP_DATA_DIR=${data_dir}/autojump
fi
if [ ! -e "${AUTOJUMP_DATA_DIR}" ]
then
    mkdir "${AUTOJUMP_DATA_DIR}"
    mv ~/.autojump_py "${AUTOJUMP_DATA_DIR}/autojump_py" 2>>/dev/null #migration
    mv ~/.autojump_py.bak "${AUTOJUMP_DATA_DIR}/autojump_py.bak" 2>>/dev/null
    mv ~/.autojump_errors "${AUTOJUMP_DATA_DIR}/autojump_errors" 2>>/dev/null
fi

AUTOJUMP='{ [[ "$AUTOJUMP_HOME" == "$HOME" ]] && (autojump -a "$(pwd -P)"&)>/dev/null 2>>${AUTOJUMP_DATA_DIR}/autojump_errors;} 2>/dev/null'
if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
  export PROMPT_COMMAND="${PROMPT_COMMAND:-:} ; $AUTOJUMP"
fi 
alias jumpstat="autojump --stat"
function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }

# Set the path for autojump
export PATH=$PATH:$HOME/.autojump/bin

# cowsay function
w00t(){ cowsay w00t; }

w00t2(){
echo ' ______'
echo '< w00t >'
echo ' ------'
echo '       \   ^__^'
echo '        \  (oo)\_______'
echo '           (__)\       )\/\'
echo '               ||----w |'
echo '               ||     ||'
}
