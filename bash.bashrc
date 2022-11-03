# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <https://creativecommons.org/publicdomain/zero/1.0/>. 

# /etc/bash.bashrc: executed by bash(1) for interactive shells.

# System-wide bashrc file

# Check that we haven't already been sourced.
([[ -z ${CYG_SYS_BASHRC} ]] && CYG_SYS_BASHRC="1") || return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# If started from sshd, make sure profile is sourced
if [[ -n "$SSH_CONNECTION" ]] && [[ "$PATH" != *:/usr/bin* ]]; then
    source /etc/profile
fi

# Warnings
unset _warning_found
for _warning_prefix in '' ${MINGW_PREFIX}; do
    for _warning_file in ${_warning_prefix}/etc/profile.d/*.warning{.once,}; do
        test -f "${_warning_file}" || continue
        _warning="$(command sed 's/^/\t\t/' "${_warning_file}" 2>/dev/null)"
        if test -n "${_warning}"; then
            if test -z "${_warning_found}"; then
                _warning_found='true'
                echo
            fi
            if test -t 1
                then printf "\t\e[1;33mwarning:\e[0m\n${_warning}\n\n"
                else printf "\twarning:\n${_warning}\n\n"
            fi
        fi
        [[ "${_warning_file}" = *.once ]] && rm -f "${_warning_file}"
    done
done
unset _warning_found
unset _warning_prefix
unset _warning_file
unset _warning

# If MSYS2_PS1 is set, use that as default PS1;
# if a PS1 is already set and exported, use that;
# otherwise set a default prompt
# of user@host, MSYSTEM variable, and current_directory
[[ -n "${MSYS2_PS1}" ]] && export PS1="${MSYS2_PS1}"
# if we have the "High Mandatory Level" group, it means we're elevated
#if [[ -n "$(command -v getent)" ]] && id -G | grep -q "$(getent -w group 'S-1-16-12288' | cut -d: -f2)"
#  then _ps1_symbol='\[\e[1m\]#\[\e[0m\]'
#  else _ps1_symbol='\$'
#fi
[[ $(declare -p PS1 2>/dev/null | cut -c 1-11) = 'declare -x ' ]] || \
  export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]$MSYSTEM\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n'"${_ps1_symbol}"' '
unset _ps1_symbol

# Uncomment to use the terminal colours set in DIR_COLORS
eval "$(dircolors -b /etc/DIR_COLORS)"

# Fixup git-bash in non login env
shopt -q login_shell || . /etc/profile.d/git-prompt.sh


#-------------------------------------------------------------------------------------------------#
# ALIAS
#-------------------------------------------------------------------------------------------------#
# alias clearKnownHostsFile="py D:/\work/\scripts/\clearKnownHostsFile.py"
alias sshdel="ssh-keygen -R"
alias clearANTONHostFile="ssh-keygen -R "anton""
alias clearGPOSHostFile="ssh-keygen -R "gpos""
alias clearCCHostFile="ssh-keygen -R "10.20.30.*""
# alias clearCCHostFile="ssh-keygen -R "cc*""

alias gotopc="cd D:/work/pc"
alias gotowork="cd D:/work/pc/git"

#-------------------------------------------------------------------------------------------------#
# GIT
#-------------------------------------------------------------------------------------------------#
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.cm commit
git config --global alias.lola "log --graph --pretty=oneline --all"

# Print Git branch beside directory name
parse_git_branch() 
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


#-------------------------------------------------------------------------------------------------#
# User prompt
#-------------------------------------------------------------------------------------------------#
# PS1="$(tput bold)$(tput setaf 7)\u@\h$(tput setaf 6){\W}\[\e[91m\]@\$(parse_git_branch)$(tput sgr0)📢";
# PS1="$(tput bold)$(tput setaf 7)\u$(tput setaf 6){\W}\[\e[91m\]@\$(parse_git_branch)$(tput sgr0)📢 ";
# export PS1;


#-------------------------------------------------------------------------------------------------#
# Powerline
#-------------------------------------------------------------------------------------------------#
# THEME=$HOME/.bash/themes/git_bash_windows_powerline/theme.bash
# if [ -f $THEME ]; then
#    . $THEME
# fi
# unset THEME


# echo '-------------------------------------------------------------------------------------------------------------------------------'
# echo '   __________                           _________                 ___________      ___.              .___  .___         .___   '
# echo '   \______   \______  _  __ ___________ \_   ___ \  ____   ____   \_   _____/ _____\_ |__   ____   __| _/__| _/____   __| _/   '
# echo '    |     ___/  _ \ \/ \/ // __ \_  __ \/    \  \/ /  _ \ /    \   |    __)_ /     \| __ \_/ __ \ / __ |/ __ |/ __ \ / __ |    '
# echo '    |    |  (  <_> )     /\  ___/|  | \/\     \___(  <_> )   |  \  |        \  Y Y  \ \_\ \  ___// /_/ / /_/ \  ___// /_/ |    '
# echo '    |____|   \____/ \/\_/  \___  >__|    \______  /\____/|___|  / /_______  /__|_|  /___  /\___  >____ \____ |\___  >____ |    '
# echo '                               \/               \/            \/          \/      \/    \/     \/     \/    \/    \/     \/    '
# echo '-------------------------------------------------------------------------------------------------------------------------------'

# printf '@ Date:                      %s \n' "$(date)"                 
# printf '@ Current user:              %s \n' "$(whoami)"       
# printf '@ Git user:                  %s \n' "$(git config user.name)"    
# printf '@ Git email:                 %s \n' "$(git config user.email)"
# printf '@ Git version:               %s \n' "$(git --version)"
# # printf '@ OpenSSH version:           %s \n' "$(ssh -V)"
# printf '@ Python3 version installed: %s \n' "$(py --version)"
# # printf '@ Python2 version installed: %s \n' "$(python2 --version)"

# # echo '-------------------------------------------------------------------------------------------------------------------------------'
# # printf '@ Kernel-name: %s                                                    \n' "$(uname -s)"
# # printf '@ Kernel-release: %s                                                 \n' "$(uname -r)"
# # printf '@ Kernel-version: %s                                                 \n' "$(uname -v)"
# # printf '@ Machine: %s                                                        \n' "$(arch)"
# # printf '@ Processor: %s                                                      \n' "$(uname -p)"
# # printf '@ Operating-system: %s                                               \n' "$(uname -o)"
# echo '-------------------------------------------------------------------------------------------------------------------------------'

# printf 'Welcome back master %s!\n' "$(whoami)"

# Init starship
eval "$(starship init bash)"
