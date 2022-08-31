
Instalacje pakietu 

sudo apt install -y libjson-perl libwww-perl

Jesli w Twojej okolicy jest dostepna informacja o pomiarach wodowskazu
na rzece możesz sprawdzic to na


Otwierajac informacje na mapie o wodowskazie obok nazwy w nawiasie bedzie informacje o ID 
wodowkazu np 

 SOBIANOWICE (151220100)

Musisz spisac tez wartosci "Stan alarmowy" oraz "Stan ostrzegwaczy" 
Dane te wpiszesz w hydro.pl 

Zrob kopie pliku hydro-cron do katalogu /etc/cron.d/

Zrob restart crontab

/etc/init.d/cron restart

Dane dla svxlink bedą umieszczane w pliku hydro.tcl w katalogu /var/spool/bulletins/

Patrz opis /opt/fmpoland/wx-info/ w pliku readme.txt 

