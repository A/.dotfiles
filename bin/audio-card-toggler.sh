#!/bin/bash

DAC_ID="22d9:0426"
ASOUNDRC="/home/anton/.asoundrc"
DAC_ASOUNDCONF="/home/anton/.dotfiles/.asoundrc_oppo_ha2"
INTERNAL_ASOUNDCONF="/home/anton/.dotfiles/.asoundrc_intel_hda"
DAC_CONNECTED=`lsusb | grep "$DAC_ID"`

if lsusb | grep ${DAC_ID}; then
  ln -sf $DAC_ASOUNDCONF $ASOUNDRC
else
  ln -sf $INTERNAL_ASOUNDCONF $ASOUNDRC
fi


