#!/usr/bin/perl
# SP2ONG Hydro Info script - poziom rzek
#  
#
#  Wykaz punktow pomiaru: https://hydro.imgw.pl/
#
# 

########## Configuration 
# ID wodowskazu
my $idstn="151170030";
# Poziom stanu alarmowego
my $alert="450";
# poziom stanu ostrzegawczego
my $warning="380";
# nazw pliku wav w /usr/share/svxlink/sounds/pl_PL/HydroInfo/
# ktory ma nagrane info np "Wodowskaz Sobianowice rzeka Bystrzyca"
my $name_river="odra_trestno";
######################

use strict;
use warnings;
use JSON qw(decode_json);
use LWP::Simple qw(get);
use Data::Dumper;              

# IMGW Hydro API JSON dane
my $url="https://danepubliczne.imgw.pl/api/data/hydro";
my $decode = eval {decode_json(get($url))};

#print length($decode);

# Zmienn lokalne dla danych z wodoskazu
my $sw=0;
my $Tsw;
my $Htime;
my $time="";
my $h1=0;
my $m1=0;


my $ids;
my $i=0;

if (-e "/var/spool/svxlink/bulletins/hydro.tcl") { unlink "/var/spool/svxlink/bulletins/hydro.tcl" };


if(!$@){

open(WX,">/var/spool/svxlink/bulletins/hydro.tcl");

# pobieranie danych dla wskazane stacji o danym ID
for ($i=0; $i<609; $i++) {

 my $id = $decode->[$i]{'id_stacji'};
 $ids = $id+0;
 $sw = $decode->[$i]{'stan_wody'};
 $time = $decode->[$i]{'stan_wody_data_pomiaru'};

# ID stacji 151220100 Sobianowice
if ( $ids eq $idstn) {
 $Tsw=$sw;
 $Htime=substr $time,11,1;
 if ($Htime==0) {
  $h1=substr $time,12,1;
  } else {
  $h1 = substr $time,11,2;
  }
  $m1=substr $time,14,2;
 }


}

# Gnerowanie pliku tcl dla svxlink

  print WX "playMsg \"HydroInfo\" \"hydro\";\n";
  print WX "playMsg \"HydroInfo\" \"$name_river\";\n";
  print WX "playMsg \"HydroInfo\" \"godzina_pomiaru\";\n";
  print WX "playTime $h1 $m1;\n";
  print WX "playMsg \"HydroInfo\" \"stan_aktualny\";\n";
  print WX "playNumber $Tsw;\n";
  print WX "playMsg \"HydroInfo\" \"unit_cm\";\n";
if ($Tsw>$alert && $Tsw < $warning) {
  print WX "playMsg \"HydroInfo\" \"przekroczony_ostrz\";\n";
 }
if ($Tsw>=$alert) {
  print WX "playMsg \"HydroInfo\" \"przekroczony_alarm\";\n";
 }

  print WX "playSilence 200;\n";
  print WX "playMsg \"HydroInfo\" \"hydro_source\";\n";

close(WX);

}
