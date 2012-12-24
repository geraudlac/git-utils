alias status='check-status.sh'
alias update='update-dev-branch.sh'

alias workon='work-on-branch.sh'
alias workon2='. work-on-branch-2.sh'

alias push='push-dev-to-master-branch.sh'

alias gitlog='git log --graph --oneline --decorate --all'
alias gitlog2="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short --decorate"
alias gitlog3="git log --graph --decorate --pretty=format:'%C(yellow)%h - %Cgreen%cr%x09%C(cyan)%d %Creset%s (%C(bold blue)%an%Creset)' --abbrev-commit --date=short"

alias gitlog40="git log --graph --decorate --abbrev-commit --date=short --pretty=format:'%C(yellow)%h#%Cgreen%cr#%C(bold blue)%an#%C(cyan)%d %Creset%s' -50"

alias gitlog41="git log --graph --decorate --abbrev-commit --date=short --pretty=format:'%C(yellow)%h#%Cgreen%cr#%C(bold blue)%an#%C(cyan)%d %Creset%s' -50 | awk -F '#' '{ printf \"%-25s %-20s %-30s %s\n\", \$1, \$2, \$3, \$4 }'"

alias gitlogext0="git log --pretty=format:'%h|%an|%s' -10"

alias gitlogext="git log --pretty=format:'%h|%an|%s' -30 | awk -F '|' '{ printf \"%s %-20s %s\n\", \$1, \$2, \$3 }'"

