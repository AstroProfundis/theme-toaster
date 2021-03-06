set __toaster_color_orange FD971F
set __toaster_color_blue 6EC9DD
set __toaster_color_green A6E22E
set __toaster_color_yellow E6DB7E
set __toaster_color_pink FA3F82
set __toaster_color_red FF2052
set __toaster_color_grey 67615E
set __toaster_color_white F1F1F1
set __toaster_color_purple 9458FF
set __toaster_color_lilac AE81FF

function __toaster_user_hostname
    __toaster_color_echo $__toaster_color_green (whoami)
    __toaster_color_echo $__toaster_color_white ":"
    __toaster_color_echo $__toaster_color_orange (hostname | cut -d"." -f1)
    __toaster_color_echo $__toaster_color_white ":"
end

function __toaster_color_echo
  set_color $argv[1]
  if test (count $argv) -eq 2
    echo -n $argv[2]
  end
end

function __toaster_current_folder
  set -l _pwd $PWD

  if test $_pwd = '/'
    set _pwd '/'
  else
    set _pwd (string replace -r "^$HOME" '~' "$_pwd")
  end

  set _pwd (string replace -ar '(\.?[^/]{1})[^/]*/' '$1/' "$_pwd")
  echo -n $_pwd
end

function __toaster_git_status_codes
  echo (git status --porcelain 2> /dev/null | sed -E 's/(^.{3}).*/\1/' | tr -d ' \n')
end

function __toaster_git_branch_name
  echo (git rev-parse --abbrev-ref HEAD 2> /dev/null)
end

function __toaster_git_merge_status
  set -l git_dir (command git rev-parse --git-dir 2> /dev/null)

  if test -e "$git_dir/rebase-merge" -o -e "$git_dir/rebase-apply"
    echo '+rebase'
  else if test -e "$git_dir/MERGE_HEAD"
    echo '+merge'
  else if test -e "$git_dir/BISECT_LOG"
    echo "+bisect"
  end
end

function __toaster_rainbow
  if echo $argv[1] | grep -q -e $argv[3]
    __toaster_color_echo $argv[2] "彡ミ"
  end
end

function __toaster_git_status_icons
  set -l git_status (__toaster_git_status_codes)

  __toaster_rainbow $git_status $__toaster_color_pink 'D'
  __toaster_rainbow $git_status $__toaster_color_orange 'R'
  __toaster_rainbow $git_status $__toaster_color_white 'C'
  __toaster_rainbow $git_status $__toaster_color_green 'A'
  __toaster_rainbow $git_status $__toaster_color_blue 'U'
  __toaster_rainbow $git_status $__toaster_color_lilac 'M'
  __toaster_rainbow $git_status $__toaster_color_grey '?'
end

function __toaster_git_status
  set -l git_branch (__toaster_git_branch_name)
  # In git
  if test -n $git_branch
    set -l merge_status (__toaster_git_merge_status)

    __toaster_color_echo $__toaster_color_blue " git"
    __toaster_color_echo $__toaster_color_white ":$git_branch"

    if test -n $merge_status
      __toaster_color_echo $__toaster_color_pink $merge_status
    end

    if test -n (__toaster_git_status_codes)
      __toaster_color_echo $__toaster_color_pink ' ●'
      __toaster_color_echo $__toaster_color_white ' [^._.^]ﾉ'
      __toaster_git_status_icons
    else
      __toaster_color_echo $__toaster_color_green ' ○'
    end
  end
end

function fish_prompt
  __toaster_color_echo $__toaster_color_blue "╭─"
  __toaster_user_hostname
  __toaster_color_echo $__toaster_color_purple (__toaster_current_folder)
  __toaster_git_status
  echo
  __toaster_color_echo $__toaster_color_blue "╰>"
  __toaster_color_echo $__toaster_color_pink "\$ "
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
     __toaster_color_echo $__toaster_color_red "►$st"
  end
end
