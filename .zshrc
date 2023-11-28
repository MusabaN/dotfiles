# pnpm
export PNPM_HOME="/Users/olenorstrand/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PKG_CONFIG_PATH=/opt/homebrew/Cellar/pixman/0.42.2/lib/pkgconfig/

# Autocomplete git
autoload -Uz compinit && compinit

# Show branch in terminal
parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
# About the prefixed `$`: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html#:~:text=Words%20in%20the%20form%20%22%24',by%20the%20ANSI%2DC%20standard.
NEWLINE=$'\n'
# Set zsh option for prompt substitution
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n@%M ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE}%% '


pruning() {
  git checkout master
  git pull origin master
  git fetch --prune
  local_branches=()
  remote_branches=()

  # Read remote branches into an array
  while IFS= read -r line; do
    remote_branches+=("$line")
    echo "Adding $line to remote branches"
  done < <(git branch -r | awk -F"/" '{print $2}' | grep -v " -> ")

  # Read local branches into an array
  while IFS= read -r line; do
    local_branches+=("$line")
    echo "Adding $line to local branches"
  done < <(git branch | sed 's/\*//' | awk '{print $1}')

  echo "Done with this biatch"

  # Reset/clear the branches-to-delete file
  rm -f /tmp/branches-to-delete.txt
  touch /tmp/branches-to-delete.txt

  # Loop over local branches
  for local_branch in "${local_branches[@]}"; do
      # Remove leading and trailing whitespaces
      local_branch_trimmed=$(echo "$local_branch" | xargs)
      echo "Checking local branch: $local_branch_trimmed"
      # If local branch is not in remote branches, add it to delete list (note: making sure again to trim whitespaces in name)
      if ! printf '%s\n' "${remote_branches[@]}" | grep -Fxq "$local_branch_trimmed"; then
        echo "$local_branch_trimmed" >> /tmp/branches-to-delete.txt
      fi
  done

  # Open the list for review
  vi /tmp/branches-to-delete.txt && xargs git branch -D </tmp/branches-to-delete.txt
}
