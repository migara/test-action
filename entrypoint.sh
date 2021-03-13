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
  cmd=`/opa eval -i ${GITHUB_WORKSPACE}/$INPUT_POLICY -d  ${GITHUB_WORKSPACE}/$INPUT_TESTS "data.panos" --format json`
  echo " 🚀 Running: $cmd"
  printf "\n"
  # eval "$cmd" || e_code=1
  opa_results=$(cmd)
  echo $opa_results
  # echo "::set-output name=opa_results::$opa_results"
  echo "::set-output name=opa_results::$(echo $opa_results)"
  printf "\n\n"
done

exit $e_code
