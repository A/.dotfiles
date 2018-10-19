#!/usr/bin/node

const fs = require('fs');
const socket = '/etc/fakedev/power_supply/BAT1/uevent';
const fullRegex = /^POWER_SUPPLY_ENERGY_FULL=(\d+)/gm;
const nowRegex = /^POWER_SUPPLY_ENERGY_NOW=(\d+)/gm;


// fs.watch(socket, () => showStatus());

function showStatus() {
  fs.readFile(socket, (err, buf) => {
    const text = buf.toString();
    const full = parseInt(fullRegex.exec(text)[1]);
    const now = parseInt(nowRegex.exec(text)[1]);
    const perc = parseInt(now/full*100);
    console.log(perc);
  });
}

showStatus();
