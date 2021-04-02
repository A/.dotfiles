Config {
       font = "xft:Iosevka:size=13:bold:antialias=true"
       , additionalFonts = [ "xft:Iosevka:size=13:bold" ]
       , allDesktops = True
       , bgColor = "#282c34"
       , fgColor = "#bbc2cf"
       , position = TopW L 100
       , commands = [ 
                      Run Com "/home/a8ka/.bin/currency" [ "BTCUSD" ] "BTCUSD" 300
                    , Run Com "/home/a8ka/.bin/currency" [ "USDRUB" ] "USDRUB" 300
                    , Run Com "/home/a8ka/.bin/currency" [ "EURRUB" ] "EURRUB" 301
                    , Run Com "/home/a8ka/.bin/coffee"   [] "coffee" 3001

                    , Run Com "/home/a8ka/.bin/newsboat-unread" [] "newsboat" 300

                    , Run WeatherX "VVTS" [ ("clear", "")
                                         , ("sunny", "")
                                         , ("mostly clear", "")
                                         , ("mostly sunny", "")
                                         , ("partly sunny", "杖")
                                         , ("fair", "")
                                         , ("cloudy","摒")
                                         , ("overcast","摒")
                                         , ("partly cloudy", "摒")
                                         , ("mostly cloudy", "歹")
                                         , ("considerable cloudiness", "朗")]
                                        [ "--template", "<fn=1><skyConditionS></fn> <tempC>°C"] 3600

                    , Run Cpu [ "--template", "<fc=#a9a1e1>CPU</fc> <total>%"
                              , "--Low","3"
                              , "--High","50"
                              , "--low","#bbc2cf"
                              , "--normal","#bbc2cf"
                              , "--high","#fb4934"] 50

                    , Run Memory ["-t","<fc=#51afef>RAM</fc> <usedratio>%"
                                 ,"-H","80"
                                 ,"-L","10"
                                 ,"-l","#bbc2cf"
                                 ,"-n","#bbc2cf"
                                 ,"-h","#fb4934"] 50

                    , Run Date "%a %b %d, %I:%M" "date" 300

                    , Run DynNetwork ["-t","<fc=#4db5bd>RX</fc> <rx>kB/s | <fc=#c678dd>TX</fc> <tx>kB/s"
                                     ,"-H","200"
                                     ,"-L","10"
                                     ,"-h","#bbc2cf"
                                     ,"-l","#bbc2cf"
                                     ,"-n","#bbc2cf"] 50

                    , Run CoreTemp ["-t", "<core0>°"
                                   , "-L", "30"
                                   , "-H", "75"
                                   , "-l", "lightblue"
                                   , "-n", "#bbc2cf"
                                   , "-h", "#aa4450"] 50

                    -- battery monitor
                    , Run BatteryP       [ "BAT0" ]
                                         [ "--template" , "<fc=#B1DE76>BAT</fc> <acstatus>"
                                         , "--Low"      , "10"        -- units: %
                                         , "--High"     , "80"        -- units: %
                                         , "--low"      , "#fb4934" -- #ff5555
                                         , "--normal"   , "#bbc2cf"
                                         , "--high"     , "#98be65"

                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"   , "<left>% (<timeleft>)"
                                                   -- AC "on" status
                                                   , "-O"   , "<left>% (<fc=#98be65>Charging</fc>)" -- 50fa7b
                                                   -- charged status
                                                   , "-i"   , "<fc=#98be65>Charged</fc>"
                                         ] 50

                    , Run Kbd [ ("us(mac)", "<fc=#c678dd>EN</fc>")
                              , ("ru(mac)"     , "<fc=#4db5bd>RU</fc>")
                              ]

                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ COFFEE = %coffee% |  = $%BTCUSD% | USD = %USDRUB%Р | EUR = %EURRUB%Р | %VVTS% | %cpu% %coretemp% | %memory% | %battery% | %dynnetwork% | RSS %newsboat% | %date% | %kbd% "   -- #69DFFA
       }
