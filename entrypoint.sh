#!/bin/bash

printf "\n\n"
echo "# Open Policy Agent"
/opa version
printf "\n\n"

IFS=';'
mapfile -t lines < <(echo "$INPUT_TESTS" | grep -v "^$")

e_code=0
for line in "${lines[@]}"; do
  read -r -a args <<< "$line"
  # cmd="/opa eval ${args[@]} $INPUT_OPTIONS"
  cmd="/opa eval -i $INPUT_POLICY -d $INPUT_TESTS "data.panos[x]" --format pretty"
  echo " 🚀 Running: $cmd"
  printf "\n"
  # echo " 🚀 Running: $1 $2 $INPUT_POLICY"
  # printf "\n"
  eval "$cmd" || e_code=1
  printf "\n\n"
done

exit $e_code