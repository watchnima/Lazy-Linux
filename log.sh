#!/bin/bash
# Author: zouxu

print_head() {
  printf "\n"
  printf "\033[32mLAZY LINUX...\n\033[0m"
  printf "\n"
}

print_term() {
  pad=$(printf '%0.1s' "."{1..100})
  padlength=80
  printf "\033[33m%s\033[0m" "${1}"
  printf "\033[33m%*.*s\n\033[0m" 0 $((padlength - ${#1})) "$pad"
}

print_error() {
  printf "\033[31m%s\n\033[0m" "error: ${1}"
}
