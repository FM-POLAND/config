Mozliwosc słuchania audio z hotspota w dashboard 
===============================================


Instalacja wymaganego pakietu nodejs:

sudo apt install -y nodejs node-ws

Idea bazuje na rozwiazaniu jakie zastosowano w dahboard DVSwitch który robiłem w 2020.
Strumien UDP aduio (48 kHz, 2 channels) z svxlink jest przekierowane
poprzez proxy w Nodejs na port 8080 dzieki temu jet możliwe przy pomocy
Web PCM Player słuchać audio online z svxlink'a

PCM Player i webproxy bazuje na rozwiazaniu

https://github.com/samirkumardas/pcm-player


Konfiguracja SVXLinka
--------------------

W pliku /etc/svxlink/svxlink.conf

Zmien w [SimplexLogic] line

TX=Tx1

na

TX=MultiTx

Dopisz poniższe linie do /etc/svxlink/svxlink.conf:


[MultiTx]
TYPE=Multi
TRANSMITTERS=Tx1,TxUDP

# Audio stream via UDP for PCM Web Player
[TxUDP]
TYPE=Local
AUDIO_DEV=udp:127.0.0.1:1235
LIMITER_THRESH=-6
AUDIO_CHANNEL=0
PTT_TYPE=NONE
TIMEOUT=7200
TX_DELAY=0
PREEMPHASIS=0


wykonac restart svxlink.conf poleceniem:

systemctl restart svxlink

--------------------------------------


Zrobic kopie pliku webproxy.service do katalogu /lib/systemd/system/

Aktywowac webproxy poleceniem:

systemctl enable webproxy
systemctl start webproxy



Kliknąć klawisz "RX Monitor" na dashbaorad w celu
aktywacji słuchania audio odbieranego na hotspocie FM
(powinien zmienić się kolor klawisza na zielony, kolor czerowny
informuje że nie działa połącznie z usługą webproxy)

-------------------
Waldek SP2ONG 2022
