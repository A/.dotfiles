Config {
    font = "Iosevka Nerd Font 12"
  , additionalFonts = [
    "xft:Sans Serif-10:normal"
  ]
  , overrideRedirect = True
  , allDesktops = True
  , bgColor = "#282c34"
  , fgColor = "#bbc2cf"
  , position = TopH 20
  , lowerOnStart = True
  , commands = [ 
      -- Run Com ".xmonad/scripts/covid-vietnam"   []           "covid"    3000
      Run Com "/home/anton/.xmonad/scripts/currency"        [ "BTCUSD" ] "BTCUSD"   300
    , Run Com "/home/anton/.xmonad/scripts/currency"        [ "USDRUB" ] "USDRUB"   300
    , Run Com "/home/anton/.xmonad/scripts/currency"        [ "EURRUB" ] "EURRUB"   300
    , Run Com "/home/anton/.xmonad/scripts/coffee"          []           "coffee"   3000
    , Run Com "python" ["~/.xmonad/scripts/next-event"]        "MEETING"  3000
    -- , Run Com "/home/anton/.xmonad/scripts/today-note"      []           "NOTE"  3000
    , Run Weather "VVTS" [
        "--template", "<skyConditionS> <tempC>°C"
      ] 3600

    , Run Cpu [ 
        "--template", "<fc=#a9a1e1>CPU</fc> <total>%"
      , "--Low","3"
      , "--High","50"
      , "--low","#bbc2cf"
      , "--normal","#bbc2cf"
      , "--high","#fb4934"
      ] 50

    , Run CpuFreq ["-t","<cpu0>GHz","-L","0","-H","2","-l","lightblue","-n","white","-h","red"] 50

    , Run Memory [
        "-t", "<fc=#51afef>RAM</fc> <usedratio>%"
      , "-H", "80"
      , "-L", "10"
      , "-l", "#bbc2cf"
      , "-n", "#bbc2cf"
      , "-h", "#fb4934"
      ] 50

    , Run Date "%a %b %d, %I:%M" "date" 300

    , Run DynNetwork [
        "-t", "<fc=#4db5bd>RX</fc> <rx>kB/s | <fc=#c678dd>TX</fc> <tx>kB/s"
      , "-H", "200"
      , "-L", "10"
      , "-h", "#bbc2cf"
      , "-l", "#bbc2cf"
      , "-n", "#bbc2cf"
      ] 50

    , Run CoreTemp [
        "-t", "<core0>°"
      , "-L", "30"
      , "-H", "75"
      , "-l", "lightblue"
      , "-n", "#bbc2cf"
      , "-h", "#aa4450"
      ] 50

    -- battery monitor
    , Run BatteryP [ "BAT0" ] [
        "--template" , "<fc=#B1DE76>BAT</fc> <acstatus>"
      , "--Low"      , "10"
      , "--High"     , "80"
      , "--low"      , "#fb4934"
      , "--normal"   , "#bbc2cf"
      , "--high"     , "#98be65"

      , "--"
      , "-o"   , "<left>% (<timeleft>)"
      , "-O"   , "<left>% (<fc=#98be65>Charging</fc>)" -- 50fa7b
      , "-i"   , "<fc=#98be65>Charged</fc>"
      ] 50

    , Run Kbd [ ("us(mac)", "<fc=#c678dd>EN</fc>")
      , ("ru(mac)"     , "<fc=#4db5bd>RU</fc>")
      ]

    , Run StdinReader
    ]

  , sepChar = "%"
  , alignSep = "}{"
  , template = "%StdinReader% } }{ BTC = $%BTCUSD% | USD = %USDRUB%Р | EUR = %EURRUB%Р | %VVTS% | %cpu% %cpufreq% %coretemp% | %memory% | %battery% | %dynnetwork% | %date% | %kbd% "   -- #69DFFA
  -- , template = " }{ %VVTS% | %cpu% %cpufreq% %coretemp% | %memory% | %battery% | %dynnetwork% | %date% | %kbd% "   -- #69DFFA
}
