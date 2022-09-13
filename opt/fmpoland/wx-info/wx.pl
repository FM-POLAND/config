#!/usr/bin/perl
#
# SP2ONG wx PERL script for openweathermap.org v20220912
#
#  You must generate own free API Key on openwathermap.org
#
#  Install package:
#  apt install -y libjson-perl libwww-perl
#

# 
######## Configuration #####################
# API Key
my $apikey="12345678901234567890";
# wspolrzedne miejsca dla ktorego chcemy pobrac pogode
# szerokosc np 53.01  
my $lat="51.219";
# dlugosc np 18.6
my $lon="22.6962";
########################################

use strict;
use warnings;
use JSON qw(decode_json);
use LWP::Simple qw(get);
use Data::Dumper;              
use Time::Piece;

my $hour=localtime->strftime('%H');

# Get weather info 

my $url="https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&lang=pl&units=metric&appid=$apikey";

my $decode = eval {decode_json(get($url))} ;

if (-e "/var/spool/svxlink/bulletins/wx.tcl") { unlink "/var/spool/svxlink/bulletins/wx.tcl" }; 

open(WX,">/var/spool/svxlink/bulletins/wx.tcl");

  print WX "playMsg \"MetarInfo\" \"wx\";\n";

if(!$@){

#print Dumper ($decode);
#print length($decode);

 my $temp = int($decode->{'main'}{'temp'});
 my $temp_feels = int($decode->{'main'}{'feels_like'});
 my $hum = $decode->{'main'}{'humidity'};
 my $pres = int($decode->{'main'}{'pressure'});
 my $winds = $decode->{'wind'}{'speed'};
 my $windd = $decode->{'wind'}{'deg'};
 my $weatherr = $decode->{'weather'}[0]{'description'};
 my $weatherid = $decode->{'weather'}[0]{'id'};
 my $rain = $decode->{'rain'}{'1h'};
 my $snow = $decode->{'snow'}{'1h'};

 my $windss="";
 my $winddd="";

# Brak danych w API v2.5
 #my $uvi = $decode->{'current'}{'uvi'};
 my $uvi="0";
 my $uv="";


if(!$rain){ $rain=0; } else {$rain = sprintf("%.1f", $rain);};
if(!$snow){ $snow=0; } else {$snow = sprintf("%.1f", $snow);};


open(WX,">/var/spool/svxlink/bulletins/wx.tcl");

  print WX "playMsg \"MetarInfo\" \"wx\";\n";
  print WX "playMsg \"MetarInfo\" \"temp_air\";\n";
  if ($temp < 0) {
        print WX "playMsg \"MetarInfo\" \"minus\";\n";
      }
  print WX "playNumber $temp;\n";

if ( $temp != $temp_feels) {
  print WX "playMsg \"MetarInfo\" \"temp_air_feels\";\n";
  if ($temp < 0) {
        print WX "playMsg \"MetarInfo\" \"minus\";\n";
      }
  print WX "playNumber $temp_feels;\n";
}
  print WX "playMsg \"MetarInfo\" \"humidity\";\n";
  print WX "playNumber $hum;\n";
  print WX "playMsg \"MetarInfo\" \"percent\";\n";
  print WX "playMsg \"MetarInfo\" \"pressure\";\n";
  print WX "playPressure $pres;\n";
  print WX "playMsg \"MetarInfo\" \"unit_hPa\";\n";

if ($winds==0.0 && $winds <= 0.2) {
   $windss="bezwietrznie";
}
if ($winds>=0.3 && $winds <= 1.5) {
   $windss="powiew";
}
if ($winds>=1.6 && $winds <= 3.3) {
   $windss="slaby";
 }
if ($winds>=3.4 && $winds <= 5.5) {
   $windss="lagodny";
 }
if ($winds>=5.5 && $winds <= 7.9) {
   $windss="umiarkowany";
 }
if ($winds>=8.0 && $winds <= 10.7) {
   $windss="dosc_silny";
 }
if ($winds>=10.8 && $winds <= 13.8) {
   $windss="silny";
 }
if ($winds>=13.9 && $winds <= 17.1) {
   $windss="bardzo_silny";
 }
if ($winds>=17.2 && $winds <= 20.7) {
   $windss="wichura";
 }
if ($winds>=20.8 && $winds <= 24.4) {
   $windss="silny_sztorm";
 }
if ($winds>=24.4 && $winds <= 28.4) {
   $windss="bardzo_silny_sztorm";
 }
if ($winds>=28.5 && $winds <= 32.6) {
   $windss="gwaltowny_silny_sztorm";
 }
if ($winds>=32.7) {
   $windss="huragan";
 }
  print WX "playMsg \"MetarInfo\" \"wind_speed\";\n";
  print WX "playMsg \"MetarInfo\" \"$windss\";\n";

if (defined $windd) {
   $windd=int($windd);
if ($windd>=0 && $windd <= 22) {
   $winddd="polnocny";
 }
if ($windd>22 && $windd <= 66) {
   $winddd="polnocno_wschodni";
 }
if ($windd>=67 && $windd <= 112) {
   $winddd="wschodni";
 }
if ($windd>112 && $windd <= 157) {
   $winddd="poludniowo_wschodni";
 }
if ($windd>157 && $windd <= 202) {
   $winddd="poludniowy";
 }
if ($windd>202 && $windd <=247 ) {
   $winddd="poludniowo_zachodni";
 }
if ($windd>247 && $windd <= 292) {
   $winddd="zachodni";
 }
if ($windd>292 && $windd <= 337) {
   $winddd="polnocno_zachodni";
 }
if ($windd>337 && $windd <= 360) {
   $winddd="polnocny";
 }
  print WX "playMsg \"MetarInfo\" \"wind_deg\";\n";
  print WX "playMsg \"MetarInfo\" \"$winddd\";\n";
}
  print WX "playMsg \"MetarInfo\" \"$weatherid\";\n";

if ($rain>0) {
  print WX "playMsg \"MetarInfo\" \"rain\";\n";
  print WX "playNumber $rain;\n";
}
if ($snow>0) {
  print WX "playMsg \"MetarInfo\" \"snow\";\n";
  print WX "playNumber $snow;\n";
}
# Brak danych UV w API v2.5
if ($uvi>0) {
  print WX "playMsg \"MetarInfo\" \"uv\";\n";
if ($uvi > 0.0 && $uvi < 3.0)
   { $uv="uv_low"; }
if ($uvi >= 3.0 && $uvi < 6.0)
   { $uv="uv_medium"; }
if ($uvi >= 6.0 && $uvi <8.9)
   { $uv="uv_high"; }
if ($uvi >= 8.0 && $uvi <= 11)
   { $uv="uv_very_high"; }
if ($uvi > 11.0 )
   { $uv="uv_extreme"; }
  print WX "playMsg \"MetarInfo\" \"$uv\";\n";
}

#  print WX "playMsg \"MetarInfo\" \"wx_source\";\n";
} else { print WX "playMsg \"MetarInfo\" \"wx_nodata\";\n"; }

close(WX);
