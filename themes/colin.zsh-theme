# VCS
COLIN_VCS_PROMPT_PREFIX1="%{$reset_color%}%{$fg[blue]%} "
COLIN_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
COLIN_VCS_PROMPT_SUFFIX="%{$reset_color%}"
COLIN_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
COLIN_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${COLIN_VCS_PROMPT_PREFIX1}git${COLIN_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$COLIN_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$COLIN_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$COLIN_VCS_PROMPT_CLEAN"

# SVN info
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${COLIN_VCS_PROMPT_PREFIX1}svn${COLIN_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$COLIN_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$COLIN_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$COLIN_VCS_PROMPT_CLEAN"

# HG info
local hg_info='$(colin_hg_prompt_info)'
colin_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${COLIN_VCS_PROMPT_PREFIX1}hg${COLIN_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
			if [ -n "$(hg status 2>/dev/null)" ]; then
				echo -n "$COLIN_VCS_PROMPT_DIRTY"
			else
				echo -n "$COLIN_VCS_PROMPT_CLEAN"
			fi
		fi
		echo -n "$COLIN_VCS_PROMPT_SUFFIX"
	fi
}

# Virtualenv
local venv_info='$(virtenv_prompt)'
COLIN_THEME_VIRTUALENV_PROMPT_PREFIX=" %{$fg[green]%}"
COLIN_THEME_VIRTUALENV_PROMPT_SUFFIX=" %{$reset_color%}%"
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo "${COLIN_THEME_VIRTUALENV_PROMPT_PREFIX}${VIRTUAL_ENV:t}${COLIN_THEME_VIRTUALENV_PROMPT_SUFFIX}"
}

local exit_code="%(?,, C:%{$fg[red]%}%?%{$reset_color%})"

# Borrowing heavily from Yad Smood's ys.zsh-theme
# Prompt format:
#
# ¶ USER@MACHINE:DIRECTORY git:BRANCH STATE WK_DAY ISO_DATE C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# ¶ colin@colputer:~/Projects/zsh-bundle git:main x 36Wed 2022-09-07T13:32:51+0100 C:130
# $
PROMPT="
%{$terminfo[bold]$fg[blue]%}¶%{$reset_color%}\
 \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$fg[white]%}@\
%{$fg[green]%}%m\
%{$fg[white]%}:\
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
 \
%{$fg[cyan]%}\
%D{%U%a} \
%{$fg[yellow]%}\
%D{%F}\
%{$fg[white]%}\
T\
%{$fg[yellow]%}\
%D{%T}\
%D{%z}\
%{$reset_color%}\
\
$exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
