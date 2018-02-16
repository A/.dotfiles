#!/bin/bash

DAC_ID="22d9:0426"
ASOUNDRC="/home/anton/.asoundrc"
DAC_ASOUNDCONF="/home/anton/.asoundrc_oppo_ha2"
INTERNAL_ASOUNDCONF="/home/anton/.asoundrc_intel_hda"
DAC_CONNECTED=`lsusb | grep "$DAC_ID"`

rm $ASOUNDRC
if lsusb | grep ${DAC_ID}; then
  ln -s $DAC_ASOUNDCONF $ASOUNDRC
else
  ln -s $INTERNAL_ASOUNDCONF $ASOUNDRC
fi


