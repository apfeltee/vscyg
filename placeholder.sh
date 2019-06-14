#!/bin/bash

function __vscyg_placeholderfunc
{
  local wanted="$1"
  echo "type 'loadvs' to get '$wanted'."
  return 1
}

function __vscyg_loadvs
{
  local vscyg_shfile="$HOME/dev/vscyg/vscyg.sh"
  if [[ -f "$vscyg_shfile" ]]; then
    unalias csc csc.exe cl cl.exe link link.exe 2>/dev/null
    source "$vscyg_shfile"
  else
    echo "cannot load '$vscyg_shfile' because it does not exist!"
  fi
}


alias csc="__vscyg_placeholderfunc csc"
alias csc.exe="__vscyg_placeholderfunc csc.exe"
alias cl="__vscyg_placeholderfunc cl"
alias cl.exe="__vscyg_placeholderfunc cl.exe"

# this is the alias that sets up $PATH, and other environment variables.
# you can name it whatever you want, obviously.
alias loadvs="__vscyg_loadvs"

