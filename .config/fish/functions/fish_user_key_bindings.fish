function fzf-complete -d 'fzf completion and print selection back to commandline'
  # As of 2.6, fish's "complete" function does not understand
  # subcommands. Instead, we use the same hack as __fish_complete_subcommand and
  # extract the subcommand manually.
  set -l cmd (commandline -co) (commandline -ct)
  switch $cmd[1]
    case env sudo
      for i in (seq 2 (count $cmd))
        switch $cmd[$i]
          case '-*'
          case '*=*'
          case '*'
            set cmd $cmd[$i..-1]
            break
        end
      end
  end
  set cmd (string join -- ' ' $cmd)

  set -l complist (complete -C$cmd)
  set -l result
  string join -- \n $complist | sort | eval (__fzfcmd) -m --select-1 --exit-0 --header '(commandline)' | cut -f1 | while read -l r; set result $result $r; end

  set prefix (string sub -s 1 -l 1 -- (commandline -t))
  for i in (seq (count $result))
    set -l r $result[$i]
    switch $prefix
      case "'"
        commandline -t -- (string escape -- $r)
      case '"'
        if string match '*"*' -- $r >/dev/null
          commandline -t --  (string escape -- $r)
        else
          commandline -t -- '"'$r'"'
        end
      case '~'
        commandline -t -- (string sub -s 2 (string escape -n -- $r))
      case '*'
        commandline -t -- (string escape -n -- $r)
    end
    [ $i -lt (count $result) ]; and commandline -i ' '
  end

  commandline -f repaint
end


function fzf-bcd-widget -d 'cd backwards'
  pwd | awk -v RS=/ '/\n/ {exit} {p=p $0 "/"; print p}' | tac | eval (__fzfcmd) +m --select-1 --exit-0 $FZF_BCD_OPTS | read -l result
  [ "$result" ]; and cd $result
  commandline -f repaint
end

function fzf-select -d 'fzf commandline job and print unescaped selection back to commandline'
  set -l cmd (commandline -j)
  [ "$cmd" ]; or return
  eval $cmd | eval (__fzfcmd) -m --tiebreak=index --select-1 --exit-0 | string join ' ' | read -l result
  [ "$result" ]; and commandline -j -- $result
  commandline -f repaint
end
function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fco -d "Use `fzf` to choose which branch to check out" --argument-names branch
  set -q branch[1]; or set branch ''
  git for-each-ref --format='%(refname:short)' refs/heads | fzf --height 10% --layout=reverse --border --query=$branch --select-1 | xargs git checkout
end

function fcoc -d "Fuzzy-find and checkout a commit"
  git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

function snag -d "Pick desired files from a chosen branch"
  # use fzf to choose source branch to snag files FROM
  set branch (git for-each-ref --format='%(refname:short)' refs/heads | fzf --height 20% --layout=reverse --border)
  # avoid doing work if branch isn't set
  if test -n "$branch"
    # use fzf to choose files that differ from current branch
    set files (git diff --name-only $branch | fzf --height 20% --layout=reverse --border --multi)
  end
  # avoid checking out branch if files aren't specified
  if test -n "$files"
    git checkout $branch $files
  end
end

function fzum -d "View all unmerged commits across all local branches"
  set viewUnmergedCommits "echo {} | head -1 | xargs -I BRANCH sh -c 'git log master..BRANCH --no-merges --color --format=\"%C(auto)%h - %C(green)%ad%Creset - %s\" --date=format:\'%b %d %Y\''"

  git branch --no-merged master --format "%(refname:short)" | fzf --no-sort --reverse --tiebreak=index --no-multi \
    --ansi --preview="$viewUnmergedCommits"
end

# Install one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [I]nstall
function vmi
  set lang $argv[1]

  if test -z $lang
    set lang (asdf plugin-list | fzf)
  end

  if ! test -z $lang
    set --local allowed_versions (asdf list-all $lang)
    set --local versions (asdf list-all $lang | fzf --tac --no-sort --multi)
    if contains $versions $allowed_versions
      for version in (echo $versions)
        asdf install $lang $version
      end
    end
  end
end
