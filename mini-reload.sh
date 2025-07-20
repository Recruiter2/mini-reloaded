#!/bin/bash

source ~/mini-reloaded/mini-reload/config.sh
# assignment name
assignment=NULL

function handle_sigint {
  echo "${RED}Script aborted by user. Cleaning up..."
  rm -R ../mini-reload
  echo ""
  echo "${GREEN}Cleaning process done.${DEFAULT}"
  exit 1
}

# Function to determine if current directory matches a pattern
detect_assignment() {
  assignment=$(basename "$(pwd)")
  [[ $assignment =~ ^C(0[0-9]|1[0-3])$ ]]
}

if detect_assignment; then
  cp -R ~/mini-reloaded/mini-reload mini-reload
  run_norminette
  trap handle_sigint SIGINT
  cd mini-reload
  ./test.sh "$assignment"
  rm -R ../mini-reload
else
  printf "${RED}Current directory does not match expected pattern (C[00~13]).${DEFAULT}\n"
  printf "${RED}Please navigate to an appropriate directory to run tests.${DEFAULT}\n"
fi

exit 1

run_norminette() {
  if command -v norminette &> /dev/null; then
    norminette
  else
    echo "norminette not found, skipping norminette checks"
  fi
}
