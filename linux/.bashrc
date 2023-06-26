# .bashrc

# custom ps1
# PS1= "[\u@\h \W]\$"
# PS1='\u@\h[\w]\[\033[00m\] '
# PS1='\u@\h[\w] $ '
PS1='\[\e[0;1;38;5;39m\]\u\[\e[0m\]@\[\e[0;1;2;38;5;83m\]\H\[\e[0m\][\[\e[0m\]\w\[\e[0m\]]\[\e[0m\] \[\e[0m\]$\[\e[0m\]:\[\e[0m\] \[\e[0m\]'
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

#Aliases
alias ls='ls -lah --color=auto'
alias bd-fix='betterdiscordctl -i flatpak install'
alias bdctl='betterdiscordctl'
alias dnf-up='sudo dnf upgrade'
alias dnf='sudo dnf'
alias rebootfw='systemctl reboot --firmware-setup'
alias powertop='sudo powertop'
alias cpufreq='sudo auto-cpufreq'
alias shutdown = 'shutdown 0'
export PATH=$PATH:/home/timmy/.spicetify

#alias mispellings
alias wxwabbitemu = 'wxWabbitemu'
alias gamemode = 'gamemoderun'