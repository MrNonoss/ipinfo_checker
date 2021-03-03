#!/usr/bin/env bash
###############################
# Pretty simple bash script
# To query ipinfo.io
# Think about adding your token as a variable
###############################
# Changelog
# 2021-03-03: Add french mobile IPs Identification thanks to AS numbers 
###############################
# HELPER
###############################
Help() {
  # Display Help
  echo -e "\e[31mipinfo_cheker helper\e[0m."
  echo
  echo "Usage:"
  echo "The synthax is pretty simple: \"ipinfo_checker.sh entryfile outfile \""
  echo
  echo "Please note two things:"
  echo -e "-->\e[41mentryfile must contains only IPs\e[0m."
  echo -e "-->You should first sort -u you entryfile to save your ipinfo API"
  echo
}
while getopts ":h" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  esac
done
###############################
token=
clear
echo "Souvenez-vous que votre fichier à traiter ne doit contenir que des adresses IP"
echo -e "\e[33m================================================\e[0m"
lines=$(cat $1 | wc -l)
count=0
echo "IP,CC,ORG,MOBILE" > $2
#AS=$(AS3215 || AS15557 || AS12626 || AS12844 || AS5410 || AS51207 || AS25117 || AS201770)
echo -e "\e[33m================================================\e[0m"
echo "Vous avez la possibilité d'effectuer deux types de recherches:"
echo "-> Une recherche courte, uniquement pour le Pays (c)"
echo "-> Une recherche longue avec le FAI et une indication d'IP mobile ou non (l)"
echo -e "\e[33m================================================\e[0m"
echo -e "\e[1;31mRappelez vous que vous avez $lines lignes a traiter\e[0m"
echo -e "\e[33m================================================\e[0m"
while true
  do
  read -r -p "Quel type de recherche? [c/l] " search
   case $search in
##############################################################
# Short Query
##############################################################
     [c])
     while read ip
       do a=$(curl --silent ipinfo.io/$ip/country?token=$token)
	   echo $ip $a >> $2
	   ((count++))
	   echo "--> $count ligne(s) sur $lines traitée(s)"
     done < $1
     echo -e "\e[1;41mJ'ai fini!\e[0m"
  break
  ;;
##############################################################
# Long Query
##############################################################
     [l])
     while read ip
       do lQueryIP=$(curl --silent ipinfo.io/$ip?token=$token | grep '"ip"\|"country"\|"org"' | tr -s "\n" "," | awk -F '"' '{print $4","$8","$12}')
	   if [[ "$lQueryIP" =~ .*"AS3215".* ]] || [[ "$lQueryIP" =~ .*"AS15557".* ]] || [[ "$lQueryIP" =~ .*"AS12626".* ]] || [[ "$lQueryIP" =~ .*"AS12844".* ]] || [[ "$lQueryIP" =~ .*"AS5410".* ]] || [[ "$lQueryIP" =~ .*"AS51207".* ]] || [[ "$lQueryIP" =~ .*"AS25117".* ]] || [[ "$lQueryIP" =~ .*"AS201770".* ]]
		then echo $lQueryIP",Mobile" >> $2
	   else echo $lQueryIP >> $2
	   fi
	   ((count++))
	   echo "--> $count ligne(s) sur $lines traitée(s)"
     done < $1
     echo -e "\e[1;41mJ'ai fini!\e[0m"
  break
  ;;
##############################################################
# False Answer
##############################################################
     *)
  echo "Un peu de sérieux, choisissez la recherche (c)ourte ou (l)ongue"
  ;;
 esac
done
