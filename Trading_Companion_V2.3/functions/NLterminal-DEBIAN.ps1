[Console]::BufferWidth = 3Dec.000
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
                $lastmonth = "Feb."
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
                $month = "Nov."
                $lastmonth = "Oct."
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
               if(($yesterdaysday -lt "01") -and ($month -eq "01")) {  
                   $yestdate = "$lastmonth $yesterday, $lastyear"
                   $yestnews = debian run "curl -s 'https://www.marketwatch.com/search?q=$prompt&m=Ticker&rpp=15&mp=2005&bd=false&rs=true' |html2text| grep -A 1000 'All Providers News' | grep -v 'All Providers News'| grep -B 1000 'Prev |' | egrep -B 2 --colour '$lastmonth $yesterday, $lastyear ' | grep -v '$month $day, $year' | sed -r 's/_/ /g'"
                   $num = 0
                   $num2 = 0
                   foreach ($line in ($yestnews)){
                        if ($line |Out-String -Stream | sls -pattern "$yestdate" ) {
                            $yesttime = $line | Out-String -Stream | %{$_.split(" ")[0]} 
                            $yestampm = $line | Out-String -Stream | %{$_.split(" ")[1]}
                            $yesttime2 = "$yestdate`t$yesttime$yestampm`t$($yestnews| Out-String -Stream |select -First ($num) | Out-String -Stream | select -Skip ($num2))"
                            $yesttime2 >> $filepath\temp.txt
                            Write-Host -ForegroundColor Cyan $yesttime2
                            $num2 = ($num + 1)
                            $num++
                        } else {
                        $num++
                        }
                   }

                   } elseif ($yesterdaysday -lt "01"){
                   $yestdate = "$lastmonth $yesterday, $year"
                   $yestnews = debian run "curl -s 'https://www.marketwatch.com/search?q=$prompt&m=Ticker&rpp=15&mp=2005&bd=false&rs=true' |html2text| grep -A 1000 'All Providers News' | grep -v 'All Providers News'| grep -B 1000 'Prev |'  | egrep -B 2 --colour '$lastmonth $yesterday, $year ' | grep -v '$month $day, $year' | sed -r 's/_/ /g'"
                   $num = 0
                   $num2 = 0
                   foreach ($line in ($yestnews)){
                        if ($line |Out-String -Stream | sls -pattern "$yestdate" ) {
                            $yesttime = $line | Out-String -Stream | %{$_.split(" ")[0]} 
                            $yestampm = $line | Out-String -Stream | %{$_.split(" ")[1]}
                            $yesttime2 = "$yestdate`t$yesttime$yestampm`t$($yestnews | Out-String -Stream |select -First ($num) | Out-String -Stream | select -Skip ($num2))"
                            $yesttime2 >> $filepath\temp.
                            Write-Host -ForegroundColor Cyan $yesttime2
                            $num2 = ($num + 1)
                            $num++
                        } else {
                        $num++
                        }
                   }
                
                   } else {
                   $yestdate = "$month $yesterday, $year"
                   $yestnews = debian run "curl -s 'https://www.marketwatch.com/search?q=$prompt&m=Ticker&rpp=15&mp=2005&bd=false&rs=true'|html2text| grep -A 1000 'All Providers News' | grep -v 'All Providers News' | grep -B 1000 'Prev |'  | egrep -B 2 '$month $yesterday, $year ' | grep -v '$month $day, $year' | sed -r 's/_/ /g'"
                   $num = 0
                   $num2 = 0
                   foreach ($line in ($yestnews)){
                        if ($line |Out-String -Stream | sls -pattern "$yestdate" ) {
                            $yesttime = $line | Out-String -Stream | %{$_.split(" ")[0]} 
                            $yestampm = $line | Out-String -Stream | %{$_.split(" ")[1]}
                            $yesttime2 = "$yestdate`t$yesttime$yestampm`t$($yestnews | Out-String -Stream |select -First ($num) | Out-String -Stream | select -Skip ($num2))"
                            Write-Host -ForegroundColor Cyan $yesttime2
#                            $yesttime2 >> $filepath\temp.txt
                            $num2 = ($num + 1)
                            $num++
                        } else {
                        $num++
                        }
                   }

                   
                   }                  
                   $toddate = "$month $day, $year"
                   $todnews = debian run "curl -s 'https://www.marketwatch.com/search?q=$prompt&m=Ticker&rpp=15&mp=2005&bd=false&rs=true'|html2text | grep -A 1000 'All Providers News'| grep -v 'All Providers News' | grep -B 1000 'Prev |'  | egrep -B 2 --colour '$month $day, $year' | sed -r 's/_/ /g'"
                   $num = 0
                   $num2 = 0
                   foreach ($line in ($todnews)){
                        if ($line |Out-String -Stream | sls -pattern "$toddate" ) {
                            $todtime = $line | Out-String -Stream | %{$_.split(" ")[0]} 
                            $todampm = $line | Out-String -Stream | %{$_.split(" ")[1]}
                            $todtime2 = "    Today`t$todtime$todampm`t$($todnews | Out-String -Stream |select -First ($num) | Out-String -Stream | select -Skip ($num2))"
                            Write-Host -ForegroundColor Green $todtime2
 #                           $todtime2 >> $filepath\temp2.txt
 #                           cat $filepath\temp2.txt |Out-String -Stream| select -Skip ($num) > $filepath\temp2.txt
                            $num2 = ($num + 1)
                            $num++
                        } else {
                        $num++
                        }
                   }
                   

                   if (($yestnews -eq $null) -and ($todnews -eq $null)) {
                   Write-Host -BackgroundColor Red "NO NEWS AVAILABLE"
                   }# else {
  #                 write-host $prompt
  #                 foreach ($line in (cat $filepath\temp.txt)){
  #                  Write-Host -ForegroundColor Cyan  $line
  #                   }
  #                  foreach ($line in (cat $filepath\temp2.txt)) {
  #                  Write-Host -ForegroundColor Green  $line
  #                   }
  #                 }
  #                 sleep -Seconds 1
  #                 rm $filepath\temp.txt
  #                 rm $filepath\temp2.txt
  #                 }
#                   if ((cat $filepath\temp.txt) -or (cat $filepath\temp2.txt)){
#                   Write-Host -ForegroundColor Cyan -Separator `n   (cat $filepath\temp.txt)
#                   Write-Host -ForegroundColor Green -Separator `n   (cat $filepath\temp2.txt)
#                   } else {

#                Write-Host -BackgroundColor Red "NO NEWS AVAILABLE"
                }
                
              
              
                
                 Write-Host $prompt

                
                }
                
                
                
#                todformula
 #               yestformula

#               if (todformula) { 
                   
 #                  } else {
 #                       Write-Host -BackgroundColor Red "NO NEWS AVAILABLE"
                               
  #                       }

   #             if (yestformula) {
  #              } else {
  #              Write-Host -BackgroundColor Red "NO NEWS AVAILABLE"
  #              }

       #Write-Host -ForegroundColor Cyan -Separator `n           
                 
             #write-host -ForegroundColor Green -Separator `n                 
                         