[Console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass

                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $filepath = (Get-Item -Path .\ -Verbose).FullName
                $month = (get-date).Month
                $year = (get-date).Year
                $lastyear = ($year - 1)


                if ($month -eq "1"){
                $month = "Jan."
                $lastmonth = "Dec."
                $lastmonthdays = 31
                } elseif ($month -eq "2"){
                $month = "Feb."
                $lastmonth = "Jan."
                $lastmonthdays = 31
                } elseif ($month -eq "3"){
                $month = "March"
                $lastmonthdays = 28
                } elseif ($month -eq "4"){
                $month = "April"
                $lastmonth = "March"
                $lastmonthdays = 31
                } elseif ($month -eq "5"){
                $month = "May"
                $lastmonth = "April"
                $lastmonthdays = 30
                } elseif ($month -eq "6"){
                $month = "June"
                $lastmonth = "May"
                $lastmonthdays = 31
                } elseif ($month -eq "7"){
                $month = "July"
                $lastmonth = "June"
                $lastmonthdays = 30
                } elseif ($month -eq "8"){
                $month = "Aug."
                $lastmonth = "July"
                $lastmonthdays = 31
                } elseif ($month -eq "9"){
                $month = "Sept."
                $lastmonth = "Aug."
                $lastmonthdays = 31
                } elseif ($month -eq "10"){
                $month = "Oct."
                $lastmonth = "Sept."
                $lastmonthdays = 30
                } elseif ($month -eq "11"){
                $lastmonth = "Nov."
                $lastmonthdays = 31
                } elseif ($month -eq "12"){
                $month = "Dec."
                $lastmonth = "Nov."
                $lastmonthdays = 30
                }

                $day = (get-date).Day
                #$day = (get-date).Day  | ForEach-Object {$_.ToString("0#")}

                if ((get-date).Dayofweek -eq "Monday") {
                $yesterdaysday = ($day - 3) #| ForEach-Object {$_.ToString("0#")}
                } else {
                $yesterdaysday = ($day - 1) #| ForEach-Object {$_.ToString("0#")}
                }

                if ($yesterdaysday -lt "1") {
                    $yesterday = ($lastmonthdays + $yesterdaysday)
                } else {
                    $yesterday = ($yesterdaysday)
                }

                while (1 -eq 1) {                                                                                                                                                                                                                                 
                $prompt = Read-Host -Prompt 'ENTER A SYMBOL (or "exit" to quit)'
                if ($prompt -eq 'exit') {
                    break
                } else {  
                clear
                echo "Retrieving News..."
                    $html = "https://query1.finance.yahoo.com/v1/finance/search?q=$prompt"
                    $res = Invoke-RestMethod -Uri $html -Headers @{ "User-Agent" = "Mozilla/5.0" }
                    $res.quotes | Select-Object symbol, shortname, exchDisp
                    # $html = Invoke-WebRequest -Uri "https://www.marketwatch.com/search?q=$prompt&ts=0&tab=All%20News" -UseBasicParsing
                    $html.RawContent > $filepath\temp
                    $source = gc $filepath\temp
                    $time = $source|Out-String -Stream|sls -pattern "$month $day, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[4]} |Out-String -Stream| %{$_.split(" ")[0]}
                    if ($time -eq "<span") {
                    $time = $source|Out-String -Stream|sls -pattern "$month $day, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[5]} |Out-String -Stream| %{$_.split(" ")[0]}
                    }
                    $ampm = $source|Out-String -Stream|sls -pattern "$month $day, $year" -AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[3]} |Out-String -Stream| %{$_.split(" ")[1]}
                    $today = $source|Out-String -Stream|sls -pattern "$month $day, $year" -AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                        if (($yesterdaysday -lt "01") -and ($month -eq "01")) {
                            $yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5| Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                            #if ($yesterdaystime -eq "<span") {
                            #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth. $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[5]} |Out-String -Stream| %{$_.split(" ")[0]}
                            #}
                            $yesterdaysampm = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(" ")[1]}
                            $yesterdaysnews = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                            $yesterdaysdate = "$yesterday,$lastmonth,$lastyear"
                        } elseif ($yesterdaysday -lt "01") {
                            $yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5| Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                            #if ($yesterdaystime -eq "<span") {
                            #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth. $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[4]} |Out-String -Stream| %{$_.split(" ")[0]}
                            #}
                            $yesterdaysampm = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(" ")[1]}
                            $yesterdaysnews = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                            $yesterdaysdate = "$yesterday,$lastmonth,$year"
                        } else {
                            $yesterdaystime = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                            #if ($yesterdaystime -eq "<span") {
                            #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$month. $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[4]} |Out-String -Stream| %{$_.split(" ")[0]}
                            #}
                            $yesterdaysampm = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream| %{$_.split(" ")[1]}
                            $yesterdaysnews = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                            $yesterdaysdate = "$yesterday,$month,$year"
                        }
                        clear
                        if ($yesterdaysnews -or $today) {
                            if ($yesterdaysnews) {
                                $lines = $yesterdaysnews |Out-String -Stream|Measure-Object -Line | Format-Wide |Out-String -Stream| ? {$_.trim() -ne "" }
                                $intnum = 0
                                     while ($intnum -le $lines - 1) {
                                         Write-Host -BackgroundColor DarkCyan "$($yesterdaystime |Out-String -Stream|Select-Object -Index $intnum)$($yesterdaysampm |Out-String -Stream|Select-Object -Index $intnum) $($yesterdaysnews|Out-String -Stream|select -Index $intnum)"
                                         $intnum ++
                                     }
                            }
                            if ($today) {
                              $lines = $today |Out-String -Stream|Measure-Object -Line | Format-Wide |Out-String -Stream| ? {$_.trim() -ne "" }
                              $intnum = 0
                                 while ($intnum -le $lines - 1) {
                                   Write-Host -BackgroundColor DarkGreen "$($time |Out-String -Stream|Select-Object -Index $intnum)$($ampm |Out-String -Stream|Select-Object -Index $intnum) $($today|Out-String -Stream|select -Index $intnum)"
                                   $intnum ++
                                 }  
                            } 
                                                
                         } else {
                                Write-Host -BackgroundColor Red NO NEWS AVAILABLE
                               
                         }
                  Write-Host $prompt
                  rm $filepath\temp
                 } 
                 }              
                 #if (gc $filepath\temp -TotalCount 5) {
                 #    gc $filepath\temp -TotalCount 5
                 #    rm $filepath\temp
                 #    Write-Host -BackgroundColor Red NO NEWS AVAILABLE
                 #    } else {
                 #    }
             
             
          
