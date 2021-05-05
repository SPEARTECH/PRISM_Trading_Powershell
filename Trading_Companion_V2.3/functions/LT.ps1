       
#       [console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass

       $filepath = (Get-Item -Path .\ -Verbose).FullName

       
        function GenerateForm { 
            #Setting up window
            [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
            [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 

            $window = New-Object System.Windows.Forms.Form 
            $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

            $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
            $OnLoadForm_StateCorrection = {
                #Correct the initial state of the form to prevent the .Net maximized form issue 
                $window.WindowState = $InitialFormWindowState 
            }

            $Tradesinput= New-Object System.Windows.Forms.TextBox
            $TradesBrowsebutton= New-Object System.Windows.Forms.Button
            $PLinput= New-Object System.Windows.Forms.TextBox
            $PLBrowsebutton= New-Object System.Windows.Forms.Button
            $todaystrades= New-Object System.Windows.Forms.Button
            $openexceldoc= New-Object System.Windows.Forms.Button
            $tradeslabel= New-Object System.Windows.Forms.Label
            $pllabel= New-Object System.Windows.Forms.Label

            $window.Text = "Trade Logging" 
            $window.DataBindings.DefaultDataSourceUpdateMode = 0 
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = (90 + 90 + 90 + 17 + 17 + 13 + 13)
            $System_Drawing_Size.Height = 225
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            #Creating Trades File Browser
            $TradesFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $TradesFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
	                Filter = '(*.csv)|*.csv' # Specified file types
                }
 
                $TradesFileBrowser.ShowDialog()

                $file = $TradesFileBrowser.FileName

                $Tradesinput.Text =$file

                If($TradesFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $TradesFileBrowser.FileName #Lists selected files (optional)
                    $Tradesinput.Text =$file
	
                }


            })

            $TradesBrowsebutton.add_Click($TradesFB)

            #Creating PL File Browser
            $PLFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $PLFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
	                Filter = '(*.csv)|*.csv' # Specified file types
                }
 
                $PLFileBrowser.ShowDialog()

                $file = $PLFileBrowser.FileName

                $PLinput.Text =$file

                If($PLFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $PLFileBrowser.FileName #Lists selected files (optional)
                    $PLinput.Text =$file
	
                }


            })

            $PLBrowsebutton.add_Click($PLFB)

            $todaystrades.add_Click({
            if (($Tradesinput.text -eq "$null") -or ($PLinput.text -eq "$null")) {
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
            $label.Text = "You must select your csv files above."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()


            } else {
########################################################
#Setting initial variables.
#$prompt = $Tradesinput.Text # -replace '"',''
$tradespath1 = $Tradesinput.Text # -replace '"',''
#$filename = $prompt| %{$_.split('\')[5]}
$filepath = "$env:USERPROFILE\Desktop"
$date = ((get-date).ToShortDateString()).replace('/','-')

$month = (get-date).Month

if ($month -eq "1"){
$month = "Jan"
} elseif ($month -eq "2"){
$month = "Feb"
} elseif ($month -eq "3"){
$month = "Mar"
} elseif ($month -eq "4"){
$month = "Apr"
} elseif ($month -eq "5"){
$month = "May"
} elseif ($month -eq "6"){
$month = "Jun"
} elseif ($month -eq "7"){
$month = "Jul"
} elseif ($month -eq "8"){
$month = "Aug"
} elseif ($month -eq "9"){
$month = "Sep"
} elseif ($month -eq "10"){
$month = "Oct"
} elseif ($month -eq "11"){
$month = "Nov"
} elseif ($month -eq "12"){
$month = "Dec"
}

$day = (get-date).Day

$year = (get-date).Year

$fulldate = "$day-$month-$year"


$contents = (gc $tradespath1)
$var = 1
$num = 1
$amt = 2

#cp $prompt $filepath\TRADES-COPY.csv

#Adding the P&L to the file.
#$final = $PLinput
# $final = $final -replace '"',''
#$finalpl = gc $final

#$finalpl = $PLinput
$plfile = $PLinput.text
$finalpl = (gc $plfile)
$pl = $finalpl.trim()[1] | Out-String -Stream| %{$_.split(",")[6]}
$ecn = $finalpl.trim()[1] | Out-String -Stream| %{$_.split(",")[3]}|Out-String -Stream
$comm = $finalpl.trim()[1] | Out-String -Stream| %{$_.split(",")[7]}|Out-String -Stream
$secfee = $finalpl.trim()[1] | Out-String -Stream| %{$_.split(",")[4]}|Out-String -Stream
$nasfee = $finalpl.trim()[1] | Out-String -Stream| %{$_.split(",")[5]}|Out-String -Stream
$totcomm = [int]$ecn + [int]$comm + [int]$secfee + [int]$nasfee

#Going through the trades, consolidating them, and writing the output to a file.
while ($contents -ne ",End"){
$amt = ($contents|Measure-Object -Line|Format-Wide|Out-String -Stream|? {$_.trim() -ne ""})   
    if ($var -eq 1){
        #Organizing the csv file by time, writing that to a new file, and making that the variable file.
        $trades2 = "$((gc $tradespath1) | select -First 1)"
        $trades2 += "`n$((gc $tradespath1) | select -Skip 1 | Out-String -Stream | Sort-Object { $_.split(',')[4] })"
        $trades2 += "`n,End"
        $contents = $trades2.Split() | Select -skip 1
    } else {
        $contents = (($contents)[($num)..$amt])
    }

    #Going through each line and setting the variables for each trade.
    for ($num = 0; $newlineorder = ($contents.Trim()[$num]|Out-String -Stream|%{$_.split(',')[1]}); $num++) {
        $firstlinesym = ($contents.Trim()[0]|Out-String -Stream|%{$_.split(',')[0]})
        $firstlineorder = ($contents.Trim()[0]|Out-String -Stream|%{$_.split(',')[1]})
        if ($firstlineorder -eq "B"){
            if ($newlineorder -ne "B"){
            $order1 = ($contents|select -First ($num))
            $shares = ($order1|sls -SimpleMatch "B"|Out-String -Stream|%{$_.split(',')[2]})|Measure-Object -sum |Format-Custom|Out-String -Stream|sls -SimpleMatch "Sum"|Out-String -Stream|%{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }
            $entry = ($order1|sls -SimpleMatch "B"|Out-String -Stream|%{$_.split(',')[3]}) | Measure-Object -Average|Format-Custom|Out-String -Stream|sls -SimpleMatch "Average"|Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }   
            $time = ($order1|sls -SimpleMatch "B"|Out-String -Stream|%{$_.split(',')[4]}|Out-String -Stream|select -First (1))
            $tempnum = $num        
                for ($num = $tempnum; $tradenum = ($contents[$tempnum..$num]|Out-String -Stream|%{$_.split(',')[2]}|Measure-Object -sum |Format-Custom|Out-String -Stream|sls -SimpleMatch "Sum"|Out-String -Stream|%{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }); $num++) {
                    if ($tradenum -eq $shares) {
                        $num++
                        $order2 = ($contents|select  -First $num) |Out-String -Stream| select -Skip $tempnum
                        $exit = ($order2|sls -SimpleMatch "S"|Out-String -Stream|%{$_.split(',')[3]}) | Measure-Object -Average|Format-Custom|Out-String -Stream|sls -SimpleMatch "Average"|Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }  
                        $difference = ($exit - $entry)
                        break
                    }
                   
                }
            break   

            }

            
        } elseif ($firstlineorder -eq "SS"){
            if ($newlineorder -ne "SS"){
            $order1 = ($contents|select -First ($num))
            $shares = ($order1|sls -SimpleMatch "SS"|Out-String -Stream|%{$_.split(',')[2]})|Measure-Object -sum |Format-Custom|Out-String -Stream|sls -SimpleMatch "Sum"|Out-String -Stream|%{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }
            $entry = ($order1|sls -SimpleMatch "SS"|Out-String -Stream|%{$_.split(',')[3]}) | Measure-Object -Average|Format-Custom|Out-String -Stream|sls -SimpleMatch "Average"|Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }   
            $time = ($order1|sls -SimpleMatch "SS"|Out-String -Stream|%{$_.split(',')[4]}|Out-String -Stream|select -First (1))
            $tempnum = $num        
                    #Finding exit price by comparing shares of the exit to the shares of the entry.
                    for ($num = $tempnum; $tradenum = ($contents[$tempnum..$num]|Out-String -Stream|%{$_.split(',')[2]}|Measure-Object -sum |Format-Custom|Out-String -Stream|sls -SimpleMatch "Sum"|Out-String -Stream|%{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }); $num++) {
                        if ($tradenum -eq $shares) {
                        $num++
                        $order2 = ($contents|select  -First $num) |Out-String -Stream| select -Skip $tempnum
                        $exit = ($order2|sls -SimpleMatch "B"|Out-String -Stream|%{$_.split(',')[3]}) | Measure-Object -Average|Format-Custom|Out-String -Stream|sls -SimpleMatch "Average"|Out-String -Stream| %{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" }  
                        $difference = ($entry - $exit)
                        break
                        }
                   
                    }
            break   

            }

            
        }
    } 
    
    #Writing line of variables to file and restarting while loop. 
    if ($difference -gt "0") {
        $newtxt += "`n$time`t$firstlinesym`t$firstlineorder`t$shares`t`t`t$entry`t$exit`t$difference"
        $profits += "`n$difference"
        } else {
        $newtxt += "`n$time`t$firstlinesym`t$firstlineorder`t$shares`t`t`t$entry`t$exit`t`t$difference"
        $profits += "`n$difference"
        }  
    $var++           
 }
 

#Getting rid of the duplicate end line from the while loop.
$newtxt2 =  $newtxt.Split([Environment]::NewLine) | Select -Skip 1 | select -SkipLast 1
$profits2 = $profits.Split([Environment]::NewLine) | Select -SkipLast 1


#Adding first line to file
$sum = ($profits2 |Measure-Object -sum |Format-Custom|Out-String -Stream|sls -SimpleMatch "Sum"|Out-String -Stream|%{$_.split("=")[1]}|Out-String -Stream|? {$_.trim() -ne "" })
echo  $fulldate`t`t`t`t"-"$totcomm`t$pl`t`t`t`t`t$sum >> "$filepath\$date-TRADES.csv"

#Creating output file.
$newtxt2 >> "$filepath\$date-TRADES.csv"

Start-Process "$filepath\$date-TRADES.csv"
}
})

            $openexceldocscript= {

                        if ((Test-Path $filepath\Config) -eq $False){
            
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
            $System_Drawing_Size.Width = 280
            $System_Drawing_Size.Height = 115
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "You have not yet configured your folders!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {

            $exceldoc = (((gc $filepath\Config).Split(2)[2]).Split('=')[1])

            if (($exceldoc) -eq "$null") {
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
            $System_Drawing_Size.Width = 280
            $System_Drawing_Size.Height = 115
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "You do not have an excel document selected!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {
                start-process ((gc $filepath\Config).Split(2)[2]).Split('=')[1]
                }

}
}
            $screenshots = New-Object System.Windows.Forms.Button
            $screenshots.Location = New-Object System.Drawing.Size (227,153)
            $screenshots.Width = 90
            $screenshots.Height = 53
            $screenshots.text = "Open Screenshots"

            $screenshots.add_Click({
            
            if ((Test-Path Config) -eq $False) {
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
            $System_Drawing_Size.Width = 280
            $System_Drawing_Size.Height = 115
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "You have not yet configured your folders!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()
            } else {

            $scfolder = (((gc $filepath\Config).Split(3)[3]).Split('=')[1])

            if (($scfolder) -eq "$null") {
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
            $System_Drawing_Size.Width = 280
            $System_Drawing_Size.Height = 115
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "You do not have a screenshot folder selected!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {
            if (Get-Childitem $scfolder * -Recurse | Where-Object {$_.CreationTime -gt (Get-Date).Date }) {

            $scfile = (Get-Childitem $scfolder * -Recurse | Where-Object {$_.CreationTime -gt (Get-Date).Date } | sort CreationTime | select -First 1).fullname
            
            start $scfile
            } else {
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
            $System_Drawing_Size.Width = 280
            $System_Drawing_Size.Height = 75
            $window.ClientSize = $System_Drawing_Size
            $window.StartPosition = 4


            $label = New-Object System.Windows.Forms.Label
            $label.Text = "Could not find today's screenshots. Make sure they're saved in your screenshots folder!"
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()
            }
            }
            }
            })

            $window.controls.Add($screenshots)
            #######################################################

            #Trades Input
            $Tradesinput.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 227
            $System_Drawing_Size.Height = 23 
            $Tradesinput.Size = $System_Drawing_Size 
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13 
            $System_Drawing_Point.Y = 43 
            $Tradesinput.Location = $System_Drawing_Point 
            $Tradesinput.DataBindings.DefaultDataSourceUpdateMode = 0 
            $InitialFormWindowState = $window.WindowState 
            $Tradesinput.text = ""

            #Trades Browse button
            $TradesBrowsebutton.TabIndex = 0
            $TradesBrowsebutton.Name = "Browse..." 
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 60
            $System_Drawing_Size.Height = 23 
            $TradesBrowsebutton.Size = $System_Drawing_Size 
            $TradesBrowsebutton.UseVisualStyleBackColor = $True
            $TradesBrowsebutton.Text = "Browse..."
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 257
            $System_Drawing_Point.Y = 42
            $TradesBrowsebutton.Location = $System_Drawing_Point 
            $TradesBrowsebutton.DataBindings.DefaultDataSourceUpdateMode = 0 

            #PL Input
            $PLinput.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 227
            $System_Drawing_Size.Height = 23 
            $PLinput.Size = $System_Drawing_Size 
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13 
            $System_Drawing_Point.Y = 113 
            $PLinput.Location = $System_Drawing_Point 
            $PLinput.DataBindings.DefaultDataSourceUpdateMode = 0 
            $InitialFormWindowState = $window.WindowState 
            $PLinput.text = ""

            #PL Browse button
            $PLBrowsebutton.TabIndex = 0
            $PLBrowsebutton.Name = "Browse..." 
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 60
            $System_Drawing_Size.Height = 23 
            $PLBrowsebutton.Size = $System_Drawing_Size 
            $PLBrowsebutton.UseVisualStyleBackColor = $True
            $PLBrowsebutton.Text = "Browse..."
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 257
            $System_Drawing_Point.Y = 112
            $PLBrowsebutton.Location = $System_Drawing_Point 
            $PLBrowsebutton.DataBindings.DefaultDataSourceUpdateMode = 0 

            #Todays Trades button
            $todaystrades.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 90
            $System_Drawing_Size.Height = 53 
            $todaystrades.Size = $System_Drawing_Size 
            $todaystrades.UseVisualStyleBackColor = $True
            $todaystrades.Text = "Calculate Today's Trades"
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13
            $System_Drawing_Point.Y = 153
            $todaystrades.Location = $System_Drawing_Point 
            $todaystrades.DataBindings.DefaultDataSourceUpdateMode = 0 

            #Open Excel Doc button
            $openexceldoc.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 90
            $System_Drawing_Size.Height = 53 
            $openexceldoc.Size = $System_Drawing_Size 
            $openexceldoc.UseVisualStyleBackColor = $True
            $openexceldoc.Text = "Open Excel Master"
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 120
            $System_Drawing_Point.Y = 153
            $openexceldoc.Location = $System_Drawing_Point 
            $openexceldoc.DataBindings.DefaultDataSourceUpdateMode = 0 
            $openexceldoc.add_Click($openexceldocscript)

            #Trades Label
            $tradeslabel.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 173
            $System_Drawing_Size.Height = 33 
            $tradeslabel.Size = $System_Drawing_Size 
            $tradeslabel.Text = "Select your csv file containing today's trades."
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13
            $System_Drawing_Point.Y = 13
            $tradeslabel.Location = $System_Drawing_Point 
            $tradeslabel.DataBindings.DefaultDataSourceUpdateMode = 0 

            #PL Label
            $pllabel.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 173
            $System_Drawing_Size.Height = 33 
            $pllabel.Size = $System_Drawing_Size 
            $pllabel.Text = "Select your csv file containing your PL for the day."
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13
            $System_Drawing_Point.Y = 83
            $pllabel.Location = $System_Drawing_Point 
            $pllabel.DataBindings.DefaultDataSourceUpdateMode = 0 

            #Add boxes
            $window.controls.Add($Tradesinput)
            $window.controls.Add($TradesBrowsebutton)
            $window.controls.Add($PLinput)
            $window.Controls.Add($PLBrowsebutton)
            $window.Controls.Add($todaystrades)
            $window.Controls.Add($openexceldoc)
            $window.Controls.Add($tradeslabel)
            $window.Controls.Add($pllabel)



            #Init the OnLoad event to correct the initial state of the form 
            $window.add_Load($OnLoadForm_StateCorrection) 

            #Show the Form 
            $window.ShowDialog()| Out-Null



}

    GenerateForm
