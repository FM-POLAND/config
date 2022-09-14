Opis jak ustawić stałą nazwę systemową np /dev/ttyUSB-SVX dla konwertera USB Serial który
będziemy używać do do detekcji otwarcia odbiornika oraz PTT w svxlink


UWAGA czasami przy wykorzystaniu USB Serial konwertera np na bazie FT232RL mogą być problemy z portem USB. 
Zawsze używaj wersji USB Serial konwerter który będziesz mógł włożyć bezpośrednio portu USB terminala 
bez używania kabla. Kiedy będą problemy z USB Serial  np że będzie znikał z systemu i będą w logu 
systemowym błędy type:

....
usb 4-1: device descriptor read/64, error -110
usb 4-1: device descriptor read/64, error -62
....

Warto spróbować wykorzystać ustawienia portów USB na terminalu poprzez założenie 
nowego pliku o nazwie "options.conf"  w katalogu /etc/modprobe.d/ poleceniem:

nano /etc/modprobe.d/options.conf

wpisać poniższą zawartość do pliku 

options usbcore use_both_schemes=y

zapisać plik i zrobić reboot terminala PC. 
Po tej operacji nasz USB Serial konwerter powinien stabilnie działać.


Włóż do komputera USB Serial konwerter i zobacz na aktualnie rozpoznane 
urządzenia USB (i zrób zrzut ekranu) wykonując polecenie:

lsusb

Teraz odłącz swój USB Serial konwerter i ponownie zrób polecenie lsusb. 

Teraz wiesz, jakie urządzenie i jaki wpis na licie zniknęło kiedy wyłączyłeś USB Serial konwerter.

Podłącz ponownie USB Serial konwerter znajdź ich identyfikatory które są w części 
ID xxxx:yyyy gdzie xxxx to idVendor a yyyy to idProduct


Na przykład FT232RL USB konwerter może wyglądać tak:

    Bus 005 Device 009: ID 0403:6001 Future Technology Devices International, Ltd FT232 Serial (UART)

gdzie mamy idVendor 0403 a idProduct 6001

Na przykład CP2122 USB konwerter może wyglądać tak:

    Bus 001 Device 007: ID 10c4:ea60 Silicon Labs CP210x UART Bridge

gdzie mamy idVendor 10c4 a idProduct ea60


Musimy utworzyć plik z regułami dla UDEV gdzie będzie podane idVendor id idProduct np:

SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="ttyUSB-SVX", GROUP="dialout", MODE="0666"

możesz pobrać przykładowy plik 99-usb-serial.rules który możesz wykorzystać wstawiając 
odpowiednie idVendor i idProdcut dla Twojego USB konwertera

cd /etc/udev/rules.d/
wget http://svxlink.pl:888/files/99-usb-serial.rules

Ustaw właściciela i uprawnienia pliku poleceniem:

chown root.root /etc/udev/rules.d/99-usb-serial.rules
chmod 644 /etc/udev/rules.d/99-usb-serial.rules

Zrób edycje pliku i wpisz dla Twojego USB Serial idVendor i idProduct

Zapisz plik i sprawdź czy użytkownik svxlink jest wymieniony w grupach dialout i tty np

tty:x:5:svxlink
dialout:x:20:svxlink


Zrób reboot komputera i sprawdź poleceniem:

ls /dev/tty*

czy na liscie jest 


    /dev/ttyUSB-SVX


jeśli tak to wpisz następnie w /etc/svxlink/svxlink.conf w [Rx1]


SERIAL_PORT=/dev/ttyUSB-SVX
SERIAL_PIN=CTS

Możesz użyć ten USB konwerter do sterowania PTT jeśli Twój terminal nie ma RS232
(np teminale Dell Wyse Dx0D itp) wtedy podłączyć do pinu RTS sterowanie PTT i w svxlink.conf
w częsci [Tx1] wpisz:

PTT_PORT=/dev/ttyUSB-SVX
PTT_PIN=RTS

i możesz zrestartować svxlink który będzie używał /dev/ttyUSB-SVX do  detekcji otwarcia odbiornika
oraz PTT.

UWAGI: Radio typu GMxxx np GM950 itp wysokość napięcia SQL jest 5V (kiedy jest otwarcie blokady)
więc sterowanie transoptora poprzez opronik 380 omów w częsci LED  4N25 powinno działać poprawnie. 
Dla BF888S wyjście SQL jest ok 2.4V więc opornik powinien mieć wartość 120 omów ale można też wyjście
SQL BF888S podać bezpośrednio na PIN CTS USB Serial konwerter nie stosując pośrednika w postaci
transoptora 4N25.

Wzór na obliczenie wartości opornika do sterowania LED w 4N25 jest

R = (Vsql -1.2V)/0.01 

gdzie Vsql wysokosć napięcia SQL

odnosząc sie do R2 na schemacie SQL na rysunku: http://svxlink.pl:888/files/hotspot-pc.pdf


------------
SP2ONG 2022




