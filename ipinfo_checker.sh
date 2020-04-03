#!/usr/bin/env bash
###############################
# Pretty simple bash script
# To query ipinfo.io
# Think about adding your token as a variable
###############################
clear
read -p "Quel fichier voulez-vous traiter? " file
read -p "Comment appelez-vous votre fichier de sortie: " done
echo -e "\e[33m================================================\e[0m"
token=937c661f3e6ff6
lines=$(cat $file | wc -l)
echo -e "\e[33m================================================\e[0m"
echo "Vous avez la possibilité d'effectuer deux types de recherches:"
echo "-> Une recherche courte, uniquement pour le Pays (c)"
echo "-> Une recherche longue avec le FAI (l)"
echo -e "\e[33m================================================\e[0m"
echo -e "\e[1;31mRappelez vous que vous avez $lines lignes a traiter\e[0m"
echo -e "\e[33m================================================\e[0m"
while true
  do
  read -r -p "Quel type de recherche? [c/l] " search
   case $search in
     [c])
     while read ip
       do a=$(curl --silent ipinfo.io/$ip/country?token=$token)
       echo $ip $a
     done < $file > $done
     echo -e "\e[1;41mJ'ai fini!\e[0m"
  break
  ;;
     [l])
     while read ip
       do curl --silent ipinfo.io/$ip?token=$token | grep '"ip"\|"country"\|"org"' | tr -d '"' | tr -d " " | cut -d ":" -f2 | tr -s "\n" "," | awk -F "," '{print $1,$2,$3}'
     done < $file > $done
     echo -e "\e[1;41mJ'ai fini!\e[0m"
  break
        ;;
     *)
  echo "Un peu de sérieux, choisissez la recherche (c)ourte ou (l)ongue"
  ;;
 esac
done
