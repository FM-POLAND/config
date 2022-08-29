Instalacja pakietow wymaganych dla PERL

apt install -y libjson-perl libwww-perl


W pliku wx.pl należy wpisac
---------------------------

Musisz wygenerowac darmowy API Key na stronie http://openweathermap.org
który należy wpsiać w:

$apikey=


nalezy podac współrzedne geograficzne miejsac dla którego bedzie pobierany info o pogodzie
możesz wspolrzedne pobrac z google map:

$lat= (szerkosc) 
$lon= (długość) 


Założyć katalog (jesli nie ma):
-------------------------------

mkdir /var/spool/svxlink/bulletins  
chown svxlink.svxlink /var/spool/svxlink/bulletins  


w którym bedzie umieszczany plik z aktualna pogoda

Skopiowac plik wx-cron do katalogu /etc/cron.d

Zrobic kopie pliku Logic.tcl do /usr/share/svxlink/events.d/local/


jesli chcesz konfiguracja poziomu rzek z dostępnego wodowskazu 
patrz do /opt/fmpoland/hydro-info/


restart cronrtab:

  /etc/init.d/cron restart

Sstem pobiera dane po pelnej godzinie 28 min i 58 min miedzy 5 a 23 godzina

Jesli chcesz sprawdzac pogode poprzez DTMF kod: 60# 

musisz dopisac w [SimplexLogic] do MODULES= 
  
MODULES=ModuleParrot,ModuleMetarInfo,ModuleMeteoInfo


Wykonać restart svxlink
------------------------

   systemctl restart svxlink
 










