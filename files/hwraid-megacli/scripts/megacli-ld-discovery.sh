#!/usr/bin/env bash
# Author: Lesovsky A.V.
# Logical drives auto-discovery via MegaCLI. VERY VERY EXPERIMENTAL (TESTED WITH 8.02.21 Oct 21, 2011)

megacli=$(which megacli)
adp_list=$(sudo $megacli adpallinfo aALL nolog |grep "^Adapter #" |cut -d# -f2)
ld_list=$(for a in $adp_list; do sudo $megacli ldinfo lall a$a nolog |grep -w "^Virtual Drive:" |awk '{print $3}' |while read ld ; do echo $a:$ld; done ; done)
first=1

if [[ $1 = raw ]]; then
  for ld in ${ld_list}; do echo $ld; done ; exit 0
fi

printf "{\n";
printf "\t\"data\":[\n\n";

for ld in ${ld_list}
do
    [ $first != 1 ] && printf ",\n";
    first=0;
    printf "\t{\n";
    printf "\t\t\"{#LD}\":\"$ld\"\n";
    printf "\t}";
done

printf "\n\t]\n";
printf "}\n";
