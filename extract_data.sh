#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") arg1 [arg2...]

Script description here.

EOF
  exit
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  args=("$@")

  # check required arguments
  [[ ${#args[@]} -eq 0 ]] && usage && die "Missing script arguments"

  return 0
}

parse_params "$@"

filelist=$(find $1 -name 'get_spc3*' -maxdepth 1 -type f  -print) 
suffix=$(echo `basename $1` | tr '[:lower:]' '[:upper:]')

for var in $filelist
do
    filename=$(basename -- "$var")
    filename=${filename/get_spc3_traffic_/}
    filename="$suffix-${filename%.*}"
    awk -f $script_dir/extract_data.awk $var > ./repo/$filename.csv 
done

# script logic here

