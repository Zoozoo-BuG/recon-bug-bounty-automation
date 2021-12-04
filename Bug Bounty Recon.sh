#!/bin/bash

target=$1

LIGHTMAGENTA="\e[95m"
BLUECOLOR="\e[34m"

if [ ! -d $target ]
then
    mkdir $target
fi

cd $target

echo -e "$LIGHTMAGENTA [+] Finding subdomains with Sublist3r..."
python3 /home/root/Documents/subwalker/tools/Sublist3r/sublist3r.py -d $target -t 10 -o subdomains.txt

echo -e "$LIGHTMAGENTA [+] Finding subdomnains with Assetfinder..."
/home/root/Documents/subwalker/tools/assetfinder/assetfinder -subs-only $target >> subdomains.txt

echo -e "$LIGHTMAGENTA [+] Sorting and Filtering outputs.."
cat subdomains.txt | sort | uniq > subdomains

echo -e "$LIGHTMAGENTA [+] Finding live subdomains with httprobe..."
cat subdomains | httprobe > alive.txt

echo -e "$LIGHTMAGENTA [+] Finding JS files..."
cat alive.txt | subjs > jsfiles

echo -e "$LIGHTMAGENTA [+] Finding subdomnain takeovers..."
subjack -w subdomains -c /home/root/go/src/github.com/haccer/subjack/fingerprints.json -t 10 -ssl -o takeovers.txt

echo -e "$LIGHTMAGENTAR [+] Fuzzing for directories..."
while read -r line
do
    python3 /home/root/Documents/dirsearch/dirsearch.py -u $line -w /home/root/Documents/wordlists/common.txt -o directory_fuzzing.txt
done < alive.txt

echo -e "$BLUECOLOR [+] Done"



