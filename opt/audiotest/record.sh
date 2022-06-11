#!/bin/bash
# Nagrywanie testowego audio do pomiaru poziomow
#
# remove old files
count=`ls -1 /var/www/html/audio/*.wav 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
rm /var/www/html/audio/*.wav
fi 
arecord -D hw:Loopback,1,4 -r 48000 -f -c1 S16_LE -d 15 /var/www/html/audio/audio-$(date +%Y-%m-%d-%H-%M-%S).wav
sleep 4




