# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#

RED='\033[0;31m'
NOCOLOR='\033[0m'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
export UPDATE_ZSH_DAYS=1
DISABLE_UPDATE_PROMPT="true"
# ENABLE_CORRECTION="true" # command autocorrection
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

export LANG=en_US.UTF-8
CASE_SENSITIVE="false"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
	git
	colored-man-pages
	zsh-autosuggestions
	zsh-syntax-highlighting
	wd
)

source $ZSH/oh-my-zsh.sh

[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

export RUST_BACKTRACE=full

eval "$(direnv hook zsh)"

[ -f $HOME/dots/aliases ] && . $HOME/dots/aliases
[ -f $HOME/dots/exports ] && . $HOME/dots/exports
[ -f $HOME/dots/links ] && . $HOME/dots/links
[ -f $HOME/dots/funcs ] && source $HOME/dots/funcs

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/dots/bin
export PATH=$PATH:$HOME/dev/data-utils/bin
export PATH=$PATH:$HOME/dev/data-utils/robot-salami
export PATH=$PATH:$HOME/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:$HOME/.pyenv/versions/3.9.2/bin
export PATH=$PATH:$HOME/.pyenv/versions/3.8.5/bin
export PATH=$PATH:$HOME/.poetry/bin

alias ls="ls -la"
# autoload -U promptinit; promptinit
# prompt pure

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc


alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir="mkdir -vp"

export PATH="$HOME/.poetry/bin:$PATH"

# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1
    else
        "$@" 8>&1 9>&2 1>&9 2>&1
    fi
}

_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  __python_argcomplete_run "$1") )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _python_argcomplete airflow

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/chrisaddy/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/chrisaddy/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chrisaddy/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/chrisaddy/bin/google-cloud-sdk/completion.zsh.inc'; fi


function mm() { mkdir -vp $1 && cd $1 }


## taskwarrior stuff
tickle () {
    deadline=$1
    shift
    in +tickle wait:$deadline $@
}
alias tick=tickle
alias think='tickle +1d'

webpage_title (){
    wget -qO- "$*" | hxselect -s '\n' -c  'title' 2>/dev/null
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}

alias rnr=read_and_review
export GOOGLE_USERNAME=chris.addy@penn-interactive.com

alias in='task add priority:inbox'
inbox () { clear && task list priority:inbox }
alias t="clear && task priority:doing or priority:emergency list"
alias ts="task sync"

doing () {
	if (( $(task priority:doing count) >= 3))
	then
		printf "${RED}reached doing WIP limit, considering finishing other work before taking on task $1${NOCOLOR}\n"
		task priority:doing list
	else
		task $1 modify priority:doing
		task $1 start
	fi
}

retro () {
	if (( $(task priority:retro count) >= 15))
	then
		printf "${RED}retro WIP limit reached, consider reviewing tasks in retro status${NOCOLOR}\n"
	fi
		task $1 modify priority:retro && task $1 stop
}

ready () { task $1 modify -in priority:ready}
backlog () { clear && task priority:ready list}
emergency () { task $1 modify priority:emergency && task $1 start }
pause () { task $1 stop }
retrospect () { clear && task priority:retro list }
fin () { task $1 done }


ide (){ tmux new-session -A -t $([ -z "$PROJECT" ] && echo $(basename "`pwd`") || echo $PROJECT) -c . }
goto (){ tmux detach; cd "$HOME/dev/$(ls ~/dev | fzf | awk '{print $NF}')" && ide }

alias rrc="robo release candidate"

source /Users/chrisaddy/.config/broot/launcher/bash/br

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc

alias login="DURATION=36000 AWS_PROFILE=default robo login && DURATION=36000 AWS_PROFILE=shared robo login"
