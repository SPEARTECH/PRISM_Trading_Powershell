       
[System.Console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass

        function GenerateForm { 

        #region Import the Assemblies 
        [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
        [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $window = New-Object System.Windows.Forms.Form 
        $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
        $OnLoadForm_StateCorrection = {
            #Correct the initial state of the form to prevent the .Net maximized form issue 
            $window.WindowState = $InitialFormWindowState 
        }

        $MNinput= New-Object System.Windows.Forms.TextBox
        $MNoutput= New-Object System.Windows.Forms.Label
        $SCANbutton= New-Object System.Windows.Forms.Button
        $Browsebutton= New-Object System.Windows.Forms.Button
        $OFbutton= New-Object System.Windows.Forms.Button
        $Stopbutton = New-Object System.Windows.Forms.Button
        $window.StartPosition = 4
        $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

        $window.Text = "News Scanner - Scan a list of stocks for news" 
        $window.DataBindings.DefaultDataSourceUpdateMode = 0 
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 500
        $System_Drawing_Size.Height = 800
        $window.ClientSize = $System_Drawing_Size
        $window.AutoScroll = $true

        #Open File Button
        $OFbutton.TabIndex = 0
        $OFbutton.Name = "Open File" 
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 80
        $System_Drawing_Size.Height = 23 
        $OFbutton.Size = $System_Drawing_Size 
        $OFbutton.UseVisualStyleBackColor = $True
        $OFbutton.Text = "Open File"
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 380
        $System_Drawing_Point.Y = 53
        $OFbutton.Location = $System_Drawing_Point 
        $OFbutton.DataBindings.DefaultDataSourceUpdateMode = 0 



        #Scan Button
        $SCANbutton.TabIndex = 0
        $SCANbutton.Name = "SCAN" 
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 150
        $System_Drawing_Size.Height = 23 
        $SCANbutton.Size = $System_Drawing_Size 
        $SCANbutton.UseVisualStyleBackColor = $True
        $SCANbutton.Text = "SCAN"
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 115
        $System_Drawing_Point.Y = 53
        $SCANbutton.Location = $System_Drawing_Point 
        $SCANbutton.DataBindings.DefaultDataSourceUpdateMode = 0 

        #Stop Button
        $Stopbutton.TabIndex = 0
        $Stopbutton.Name = "Stop" 
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 50
        $System_Drawing_Size.Height = 23 
        $Stopbutton.Size = $System_Drawing_Size 
        $Stopbutton.UseVisualStyleBackColor = $True
        $Stopbutton.Text = "Stop"
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 213
        $System_Drawing_Point.Y = 53
        $Stopbutton.Location = $System_Drawing_Point 
        $Stopbutton.DataBindings.DefaultDataSourceUpdateMode = 0 


        #Browse button
        $Browsebutton.TabIndex = 0
        $Browsebutton.Name = "Browse..." 
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 60
        $System_Drawing_Size.Height = 23 
        $Browsebutton.Size = $System_Drawing_Size 
        $Browsebutton.UseVisualStyleBackColor = $True
        $Browsebutton.Text = "Browse..."
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 423
        $System_Drawing_Point.Y = 12
        $Browsebutton.Location = $System_Drawing_Point 
        $Browsebutton.DataBindings.DefaultDataSourceUpdateMode = 0 

        #Creating File Browser
        $filebrowser=({
            Add-Type -AssemblyName System.Windows.Forms
            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                Multiselect = $false # Multiple files can be chosen
	            Filter = '(*.csv)|*.csv' # Specified file types
            }
 
            $FileBrowser.ShowDialog()

            $file = $FileBrowser.FileName

            $MNinput.Text =$file

            If($FileBrowser.FileNames -like "*\*") {

	            # Do something 
	            $file = $FileBrowser.FileName #Lists selected files (optional)
                $MNinput.Text =$file
	
            } else {
                Write-Host "Cancelled by user"
            }
        })

        $Browsebutton.add_Click($filebrowser)

        #Scan Button script
        ##################################################
        ###################################################
        $SCANscript = {

                        if (($MNinput.Text) -eq "$null"){
          
             
                        $window = New-Object System.Windows.Forms.Form 
            $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

            $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
            $OnLoadForm_StateCorrection = {
                #Correct the initial state of the form to prevent the .Net maximized form issue 
                $window.WindowState = $InitialFormWindowState 
            }
            $window.Text = "Error" 
            $window.DataBindings.DefaultDataSourceUpdateMode = 0 
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 225
            $System_Drawing_Size.Height = 75
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "Please select your csv file above."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
 #           $window.Controls.Add($window)
            $window.ShowDialog()
            } else {

#        $window.Controls.Add($Stopbutton)

        
#        $Stopbutton.add_Click({

#})


        #getting the filename and path from the user
        $prompt = $MNinput.Text
        $prompt = $prompt -replace '"',''
        $filepath = split-path $prompt
        $contents = gc $prompt
        $date = ((get-date).ToShortDateString()).replace('/','-')
        #$filepath = (Get-Item -Path .\ -Verbose).FullName
        $month = (get-date).Month
        $year = (get-date).Year
        $lastyear = ($year - 1)


        $day = (get-date).Day



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

        cd $filepath

        $MNoutput.Text = "Retrieving news..."

        #creating variables for sym,price,vol,flt.
        $symnum = 0
        if ($contents.trim()[0]|Out-String -Stream|sls '"Symbol"') {
          if (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$symnum]}) -eq "Symbol") {
            $symbols = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                           $contents2.split('"')[$symnum]
                       }
          } else {
            while (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$symnum]}) -ne "Symbol") {
                $symnum++
                $symbols = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                               $contents2.split('"')[$symnum]
                           }
            }
          }
        } else {
            $MNoutput= "Could not find Symbols in the csv file. Please ensure you're scanner has a 'Symbols' column."
   
        }

        $pricenum = 0
        if ($contents.trim()[0]|Out-String -Stream|sls '"Price"') {
           if (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$pricenum]}) -eq "Price") {
               $price = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
               $contents2.split('"')[$pricenum]
           }
        } else {
            while (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$pricenum]}) -ne "Price") {
                $pricenum++
                $price = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                         $contents2.split('"')[$pricenum]
                         }
            }
        }
        }

        $volnum = 0
        if ($contents.trim()[0]|Out-String -Stream|sls '"Volume Today"') {
            if (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$volnum]}) -eq "Volume Today") {
                $volume = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                $contents2.split('"')[$volnum]
            }
        } else {
            while (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$volnum]}) -ne "Volume Today") {
            $volnum++
            $volume = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                      $contents2.split('"')[$volnum]
                      }
            }
        }
        }

        $fltnum = 0
        if ($contents.trim()[0]|Out-String -Stream|sls '"Float"') {
            if (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$fltnum]}) -eq "Float") {
                $float = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                             $contents2.split('"')[$fltnum]
                         }
            } else {
                while (($contents.trim()[0]|Out-String -Stream| %{$_.split('"')[$fltnum]}) -ne "Float") {
                    $fltnum++
                    $float = for ($num = 1; $contents2 = $contents.trim()[$num]; $num++) {
                                 $contents2.split('"')[$fltnum]
                              }
                }
            }
        }

        $amt = $symbols.Length
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        #loop for getting news and writing to a file
        #$temp = 'Symbol , Price , Volume , Float'
        #echo "Symbol , Price , Volume , Float" >> "$filepath\NEWS-SCAN_$date.txt"
        #$temp += "`n-----------------------------------------------"  
        
                for ($num = 0; $symbol = $symbols.trim()[$num]; $num++) {
                     [System.Windows.Forms.Application]::DoEvents()
                     $html = Invoke-WebRequest -Uri "https://www.marketwatch.com/search?q=$symbol&m=Ticker&rpp=100&mp=2005&bd=false&rs=true" -UseBasicParsing
                     $html.RawContent > $filepath\temp
                     $source = gc $filepath\temp
                     $todtime = $source|Out-String -Stream|sls -pattern "$month $day, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[5]} |Out-String -Stream| %{$_.split(" ")[0]}
  <#                   if ($time -eq "<span") {
                     $todtime = $source|Out-String -Stream|sls -pattern "$month $day, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[5]} |Out-String -Stream| %{$_.split(" ")[0]}
                     }
 #>                  $ampm = $source|Out-String -Stream|sls -pattern "$month $day, $year" -AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[3]} |Out-String -Stream| %{$_.split(" ")[1]}
                     $todnews = $source|Out-String -Stream|sls -pattern "$month $day, $year" -AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}                        
                        if (($yesterdaysday -lt "01") -and ($month -eq "01")) {
                             $yestdate = "$yesterday,$lastmonth,$lastyear"
                             $yesttime = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5| Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                             #if ($yesterdaystime -eq "<span") {
                             #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth. $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[5]} |Out-String -Stream| %{$_.split(" ")[0]}
                             #}
                             $yestampm = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(" ")[1]}
                             $yestsnews = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $lastyear"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                         } elseif ($yesterdaysday -lt "01") {
                             $yestdate = "$yesterday,$lastmonth,$year"
                             $yesttime = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5| Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                             #if ($yesterdaystime -eq "<span") {
                             #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$lastmonth. $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[4]} |Out-String -Stream| %{$_.split(" ")[0]}
                             #}
                             $yestampm = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(" ")[1]}
                             $yestnews = $source|Out-String -Stream|sls -pattern "$lastmonth $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                         } else {
                             $yestdate = "$yesterday,$month,$year"
                             $yesttime = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]} |Out-String -Stream| %{$_.split(">")[2]}|Out-String -Stream| %{$_.split(" ")[0]}
                             #if ($yesterdaystime -eq "<span") {
                             #$yesterdaystime = $source|Out-String -Stream|sls -pattern "$month. $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split(">")[4]} |Out-String -Stream| %{$_.split(" ")[0]}
                             #}
                             $yestampm = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls  -Pattern "<span" -Context 0,0 | Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream| %{$_.split(" ")[1]}
                             $yestnews = $source|Out-String -Stream|sls -pattern "$month $yesterday, $year"-AllMatches -Context 5,5 | Out-String -Stream| sls -Pattern "href" -AllMatches -SimpleMatch -Context 0,5 | Out-String -Stream | sls -Pattern "href" -Context 0,0 | Out-String -Stream | %{$_.split(">")[2]} | Out-String -Stream | %{$_.split("<")[0]}
                         }

            $price2 = $price.trim()[$num]
            $volume2 = $volume.trim()[$num]
            $float2 = $float.trim()[$num]
            $symup = $symbol.ToUpper()
            if ($todnews -or $yestnews) {
                $temp +=  "`n-----------------------------------------------"
                $temp +=  "`n$symup | `$$price2 | Vol: $volume2 | Flt: $float2"
                $temp +=  "`n-----------------------------------------------"
                }
            if ($todnews -ne $null) {
                 $lines = $todnews |Out-String -Stream|Measure-Object -Line | Format-Wide |Out-String -Stream| ? {$_.trim() -ne "" }
                 $intnum = 0
                 $temp += "`n"
                 $temp += "`nToday"
                 while ($intnum -le $lines - 1) {
                    $temp += "`n$($todtime | Out-String -Stream | select -Index $intnum)$($ampm | Out-String -Stream | select -Index $intnum)    $($todnews|Out-String -Stream|select -Index $intnum)"
                    $intnum ++
                    }
                 }
             if ($yestnews -ne $null) {
                 $lines = $yestnews |Out-String -Stream|Measure-Object -Line | Format-Wide |Out-String -Stream| ? {$_.trim() -ne "" }
                 $intnum = 0
                 $temp += "`n"
                 $temp += "`n$yestdate"
                 while ($intnum -le $lines - 1) {
                     $temp += "`n$($yesttime | Out-String -Stream | select -Index $intnum)$($yestampm | Out-String -Stream | select -Index $intnum)    $($yestnews|Out-String -Stream|select -Index $intnum)"
                     $intnum ++
                 }
            }
                         $MNoutput.Refresh()
            $MNoutputnews = $temp
             $MNoutput.text = ("$($num + 1)/$amt Complete.
             $temp")
        $todnews = $null
        $yestnews = $null
             }
             
                          $MNoutput.Refresh()
 #               $file = "$filepath\NEWS-SCAN_$date.txt"
               
                

        
        if (($temp) -ne $null){
             $MNoutput.text = ("Scan Complete.
             $temp")
             $temp >> "$filepath\NEWS_SCAN-$date.txt"

        $window.Controls.Add($OFbutton)
        #Open File Button
        $window.Controls.Add($OFbutton)


        $OFbutton.add_Click({
                $prompt = $MNinput.Text
        $prompt = $prompt -replace '"',''
        $filepath = split-path $prompt
                $date = ((get-date).ToShortDateString()).replace('/','-')
        #$filepath = (Get-Item -Path .\ -Verbose).FullName
        $month = (get-date).Month
        $year = (get-date).Year
        $lastyear = ($year - 1)


        $day = (get-date).Day

        $file = "$filepath\NEWS_SCAN-$date.txt"
        Start-Process "$file"
        })
        rm $filepath\temp

        } else {
            $MNoutput.Refresh()
            $MNoutput.text = ("No news was found.
             $temp")

            }

            }
        }
               $SCANbutton.add_Click($SCANscript)
<#               $MNinput.Refresh()
      
                if (($MNinput.Text) -eq "$null"){
          
             
                        $window = New-Object System.Windows.Forms.Form 
            $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

            $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
            $OnLoadForm_StateCorrection = {
                #Correct the initial state of the form to prevent the .Net maximized form issue 
                $window.WindowState = $InitialFormWindowState 
            }
            $window.Text = "Error" 
            $window.DataBindings.DefaultDataSourceUpdateMode = 0 
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 260
            $System_Drawing_Size.Height = 75
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "You must select your csv file above."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
 #           $window.Controls.Add($window)
            $window.ShowDialog()
            
            

                }else{

#>                 
    
#                }
            
        
        #Read-Host -prompt 'Press any key to exit' 
        ####################################################
        ####################################################

        #MN Input
        $MNinput.TabIndex = 0
        $System_Drawing_Size = New-Object System.Drawing.Size 
        $System_Drawing_Size.Width = 393
        $System_Drawing_Size.Height = 23 
        $MNinput.Size = $System_Drawing_Size 
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 13 
        $System_Drawing_Point.Y = 13 
        $MNinput.Location = $System_Drawing_Point 
        $MNinput.DataBindings.DefaultDataSourceUpdateMode = 0 
        $InitialFormWindowState = $window.WindowState 
        $MNinput.text = ""

        #MN Output
        $MNoutput.TabIndex = 0
        $System_Drawing_Size.Width = 1000
        $System_Drawing_Size.Height = 5000
        $MNoutput.Size = $System_Drawing_Size 
        $System_Drawing_Point = New-Object System.Drawing.Point 
        $System_Drawing_Point.X = 13 
        $System_Drawing_Point.Y = 93
        $MNoutput.Location = $System_Drawing_Point 
        $MNoutput.DataBindings.DefaultDataSourceUpdateMode = 0 
        $InitialFormWindowState = $window.WindowState 


        #Add boxes
        $window.controls.Add($MNinput)
        $window.controls.Add($SCANbutton)
        $window.controls.Add($MNoutput)
        $window.Controls.Add($Browsebutton)


        #Init the OnLoad event to correct the initial state of the form 
        $window.add_Load($OnLoadForm_StateCorrection) 

        #Show the Form 
        $window.ShowDialog()| Out-Null

        } #End Function

        #Call the Function 
        GenerateForm 
