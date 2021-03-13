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
  # cmd=`/opa eval -i ${GITHUB_WORKSPACE}/$INPUT_POLICY -d  ${GITHUB_WORKSPACE}/$INPUT_TESTS "data.panos" --format json`
  cmd=`/opa eval -i ${GITHUB_WORKSPACE}/$INPUT_POLICY -d  ${GITHUB_WORKSPACE}/$INPUT_TESTS "data.panos"`
  eval_output=$(echo $cmd)
  echo " 🚀 Result: $eval_output"
  # printf "\n"
  # eval "$cmd" || e_code=1
  # opa_results=$(cmd)
  # echo $opa_results
  # echo "::set-output name=opa_results::$opa_results"

  # https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/m-p/38372/highlight/true#M3322
  eval_output="${eval_output//'%'/'%25'}"
  eval_output="${eval_output//$'\n'/'%0A'}"
  eval_output="${eval_output//$'\r'/'%0D'}"

  echo "::set-output name=opa_results::${eval_output}"
  # echo "::set-output name=opa_results::foo"
  # printf "\n\n"
done

exit $e_code
