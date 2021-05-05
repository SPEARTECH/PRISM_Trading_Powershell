[Console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass
#$filepath = (Get-Item -Path .\ -Verbose).FullName
#cd $filepath


function GenerateForm { 


    #region Import the Assemblies 
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null 
#Free ressources
<#  


    # fileToolStripMenuItem
    #
    $Settings.DropDownItems.AddRange(@(
    $Configuration))
    $Configuration.Name = "Configuration"
    $Configuration.Size = new-object System.Drawing.Size(35, 20)
    $Configuration.Text = "Configuration"

$Configuration.Name = "openToolStripMenuItem"
$Configuration.Size = new-object System.Drawing.Size(152, 22)
$Configuration.Text = "&Open"


$Configuration.Add_Click({

})
#>
$filepath = (Get-Item -Path .\ -Verbose).FullName
    $window = New-Object System.Windows.Forms.Form 
    $TIbutton = New-Object System.Windows.Forms.Button 
    $STbutton = New-Object System.Windows.Forms.Button 
    $Chatbutton = New-Object System.Windows.Forms.Button 
    $NLbutton = New-Object System.Windows.Forms.Button
    $MNbutton = New-Object System.Windows.Forms.Button
    $LTbutton = New-Object System.Windows.Forms.Button
    $MS_Main = new-object System.Windows.Forms.MenuStrip
    $window.StartPosition = 4
    $window.Text = "V2.1"

    #Load external assemblies
#[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$MS_Main = new-object System.Windows.Forms.MenuStrip
$fileToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
$openToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
#
# MS_Main
#
$MS_Main.Items.AddRange(@(
$fileToolStripMenuItem))
$MS_Main.Location = new-object System.Drawing.Point(0, 0)
$MS_Main.Name = "MS_Main"
$MS_Main.Size = new-object System.Drawing.Size(354, 24)
$MS_Main.TabIndex = 0
$MS_Main.Text = "menuStrip1"
$MS_Main.BackColor = '#E5E4E2'

#
# fileToolStripMenuItem
#
$fileToolStripMenuItem.DropDownItems.AddRange(@(
$openToolStripMenuItem))
$fileToolStripMenuItem.Name = "fileToolStripMenuItem"
$fileToolStripMenuItem.Size = new-object System.Drawing.Size(35, 20)
$fileToolStripMenuItem.Text = "Settings"
#
# openToolStripMenuItem
#
$openToolStripMenuItem.Name = "openToolStripMenuItem"
$openToolStripMenuItem.Size = new-object System.Drawing.Size(152, 22)
$openToolStripMenuItem.Text = "Configure"

$openToolStripMenuItem.add_Click({
function Generateform {    
    $window = New-Object System.Windows.Forms.Form 

    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
    
    $chatpathtext = New-Object System.Windows.Forms.TextBox
    $chatpathbrowse = New-Object System.Windows.Forms.Button
    $chatpathlabel = New-Object System.Windows.Forms.Label


    $scanpathtext = New-Object System.Windows.Forms.TextBox
    $scanpathbrowse = New-Object System.Windows.Forms.Button
    $scanpathlabel = New-Object System.Windows.Forms.Label
    
    $tradepathtext = New-Object System.Windows.Forms.TextBox
    $tradepathbrowse = New-Object System.Windows.Forms.Button
    $tradepathlabel = New-Object System.Windows.Forms.Label

    $ltpathtext = New-Object System.Windows.Forms.TextBox
    $ltpathbrowse = New-Object System.Windows.Forms.Button
    $ltpathlabel = New-Object System.Windows.Forms.Label

    $update = New-Object System.Windows.Forms.Button
        $window.StartPosition = 4
        $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

    $OnLoadForm_StateCorrection = {
    #Correct the initial state of the form to prevent the .Net maximized form issue 
        $window.WindowState = $InitialFormWindowState 
    }

    #Window settings
    $window.Text = "Configuration" 
    $window.DataBindings.DefaultDataSourceUpdateMode = 0 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 290
    $System_Drawing_Size.Height = 425
    $window.ClientSize = $System_Drawing_Size

        #Chat Path Label
    $chatpathlabel.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $chatpathlabel.Size = $System_Drawing_Size 
    $chatpathlabel.Text = "Chat Software .exe:"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 13
    $chatpathlabel.Location = $System_Drawing_Point 
    $chatpathlabel.DataBindings.DefaultDataSourceUpdateMode = 0 

    #Chat Path Text Box
    $chatpathtext.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 23 
    $chatpathtext.Size = $System_Drawing_Size 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 43 
    $chatpathtext.Location = $System_Drawing_Point 
    $chatpathtext.DataBindings.DefaultDataSourceUpdateMode = 0 
    $InitialFormWindowState = $window.WindowState 
    $chatpathtext.text = (gc $filepath\Config).Trim()[4] | Out-String -Stream| %{$_.split("=")[1]}

    #Chat Path Browse Button
    $chatpathbrowse.TabIndex = 0
    $chatpathbrowse.Name = "Browse..." 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $chatpathbrowse.Size = $System_Drawing_Size 
    $chatpathbrowse.UseVisualStyleBackColor = $True
    $chatpathbrowse.Text = "Browse..."
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 203
    $System_Drawing_Point.Y = 42
    $chatpathbrowse.Location = $System_Drawing_Point 
    $chatpathbrowse.DataBindings.DefaultDataSourceUpdateMode = 0 

                $ChatFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $chatFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
	                Filter = '(*.exe)|*.exe' # Specified file types
                }
 
                $chatFileBrowser.ShowDialog()

                $file = $ScanFileBrowser.FileName

                $chatpathtext.Text =$file

                If($chatFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $chatFileBrowser.FileName #Lists selected files (optional)
                    $chatpathtext.Text =$file
	
                }


            })

            $chatpathbrowse.add_Click($ChatFB)


    #Scanner Path Label
    $scanpathlabel.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $scanpathlabel.Size = $System_Drawing_Size 
    $scanpathlabel.Text = "Stock Scanner .exe:"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 83
    $scanpathlabel.Location = $System_Drawing_Point 
    $scanpathlabel.DataBindings.DefaultDataSourceUpdateMode = 0 

    #Scanner Path Text Box
    $scanpathtext.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 23 
    $scanpathtext.Size = $System_Drawing_Size 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 113 
    $scanpathtext.Location = $System_Drawing_Point 
    $scanpathtext.DataBindings.DefaultDataSourceUpdateMode = 0 
    $InitialFormWindowState = $window.WindowState 
    $scanpathtext.text = (gc $filepath\Config).Trim()[0] | Out-String -Stream| %{$_.split("=")[1]}

    #Scanner Path Browse Button
    $scanpathbrowse.TabIndex = 0
    $scanpathbrowse.Name = "Browse..." 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $scanpathbrowse.Size = $System_Drawing_Size 
    $scanpathbrowse.UseVisualStyleBackColor = $True
    $scanpathbrowse.Text = "Browse..."
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 203
    $System_Drawing_Point.Y = 112
    $scanpathbrowse.Location = $System_Drawing_Point 
    $scanpathbrowse.DataBindings.DefaultDataSourceUpdateMode = 0 

                $ScanFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $ScanFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
	                Filter = '(*.exe)|*.exe' # Specified file types
                }
 
                $ScanFileBrowser.ShowDialog()

                $file = $ScanFileBrowser.FileName

                $scanpathtext.Text =$file

                If($scanFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $scanFileBrowser.FileName #Lists selected files (optional)
                    $scanpathtext.Text =$file
	
                }


            })

            $scanpathbrowse.add_Click($ScanFB)


    $scpathlabel = New-Object System.Windows.Forms.Label
    $scpathtext = New-Object System.Windows.Forms.TextBox
    $scpathbrowse = New-Object System.Windows.Forms.Button




    #Trading Software Path Label
    $tradepathlabel.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $tradepathlabel.Size = $System_Drawing_Size 
    $tradepathlabel.Text = "Trading Platform .exe:"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 153
    $tradepathlabel.Location = $System_Drawing_Point 
    $tradepathlabel.DataBindings.DefaultDataSourceUpdateMode = 0 

    #Trade Software Path Text Box
    $tradepathtext.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 23 
    $tradepathtext.Size = $System_Drawing_Size 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 183 
    $tradepathtext.Location = $System_Drawing_Point 
    $tradepathtext.DataBindings.DefaultDataSourceUpdateMode = 0 
    $InitialFormWindowState = $window.WindowState 
    $tradepathtext.text = (gc $filepath\Config).Trim()[1] | Out-String -Stream| %{$_.split("=")[1]}

    #Trade Software Path Browse Button
    $tradepathbrowse.TabIndex = 0
    $tradepathbrowse.Name = "Browse..." 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $tradepathbrowse.Size = $System_Drawing_Size 
    $tradepathbrowse.UseVisualStyleBackColor = $True
    $tradepathbrowse.Text = "Browse..."
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 203
    $System_Drawing_Point.Y = 182
    $tradepathbrowse.Location = $System_Drawing_Point 
    $tradepathbrowse.DataBindings.DefaultDataSourceUpdateMode = 0 

                    $TradeFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $TradeFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
	                Filter = '(*.exe)|*.exe' # Specified file types
                }
 
                $TradeFileBrowser.ShowDialog()

                $file = $TradeFileBrowser.FileName

                $tradepathtext.Text =$file

                If($TradeFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $TradeFileBrowser.FileName #Lists selected files (optional)
                    $tradepathtext.Text =$file
	
                }


            })

            $tradepathbrowse.add_Click($TradeFB)


    #Trade Logging Path Label
    $ltpathlabel.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $ltpathlabel.Size = $System_Drawing_Size 
    $ltpathlabel.Text = "Trade Log File:"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 223
    $ltpathlabel.Location = $System_Drawing_Point 
    $ltpathlabel.DataBindings.DefaultDataSourceUpdateMode = 0 

    #Trade Logging Path Text Box
    $ltpathtext.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 23 
    $ltpathtext.Size = $System_Drawing_Size 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 253 
    $ltpathtext.Location = $System_Drawing_Point 
    $ltpathtext.DataBindings.DefaultDataSourceUpdateMode = 0 
    $InitialFormWindowState = $window.WindowState 
    $ltpathtext.text = (gc $filepath\Config).Trim()[2] | Out-String -Stream| %{$_.split("=")[1]}

    #Trade Logging Path Browse Button
    $ltpathbrowse.TabIndex = 0
    $ltpathbrowse.Name = "Browse..." 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $ltpathbrowse.Size = $System_Drawing_Size 
    $ltpathbrowse.UseVisualStyleBackColor = $True
    $ltpathbrowse.Text = "Browse..."
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 203
    $System_Drawing_Point.Y = 252
    $ltpathbrowse.Location = $System_Drawing_Point 
    $ltpathbrowse.DataBindings.DefaultDataSourceUpdateMode = 0 

                    $LogFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $LogFileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
                    Multiselect = $false # Multiple files can be chosen
                }
 
                $LogFileBrowser.ShowDialog()

                $file = (($LogFileBrowser.FileName)|Out-String -Stream| ? $_.Trim() -ne)

                $ltpathtext.Text =$file

                If($LogFileBrowser.FileNames -like "*\*") {

	                # Do something 
	                $file = $LogFileBrowser.FileName #Lists selected files (optional)
                    $ltpathtext.Text =$file
	
                }


            })

            $ltpathbrowse.add_Click($LogFB)

        #sc Label
    $scpathlabel.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $scpathlabel.Size = $System_Drawing_Size 
    $scpathlabel.Text = "Screenshots Main Folder:"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 293
    $scpathlabel.Location = $System_Drawing_Point 
    $scpathlabel.DataBindings.DefaultDataSourceUpdateMode = 0 

    #sc Path Text Box
    $scpathtext.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 23 
    $scpathtext.Size = $System_Drawing_Size 
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 323 
    $scpathtext.Location = $System_Drawing_Point 
    $scpathtext.DataBindings.DefaultDataSourceUpdateMode = 0 
    $InitialFormWindowState = $window.WindowState 
    $scpathtext.text = (gc $filepath\Config).Trim()[3] | Out-String -Stream| %{$_.split("=")[1]}

    #sc Path Browse Button
    $scpathbrowse.TabIndex = 0
    $scpathbrowse.Name = "Browse..." 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $scpathbrowse.Size = $System_Drawing_Size 
    $scpathbrowse.UseVisualStyleBackColor = $True
    $scpathbrowse.Text = "Browse..."
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 203
    $System_Drawing_Point.Y = 322
    $scpathbrowse.Location = $System_Drawing_Point 
    $scpathbrowse.DataBindings.DefaultDataSourceUpdateMode = 0 

                $scFB=({
                Add-Type -AssemblyName System.Windows.Forms
                $scFileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
                }
 
                $scFileBrowser.ShowDialog()

                $file = $scFileBrowser.SelectedPath

                $scpathtext.Text =$file

                #If($scFileBrowser.filenames -like "*\*") {

	                # Do something 
	            #    $file = $scFileBrowser.FileName #Lists selected files (optional)
                #    $scpathtext.Text =$file
	
                #}


            })

            $scpathbrowse.add_Click($scFB)


    #Update Button
    $update.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 23 
    $update.Size = $System_Drawing_Size 
    $update.UseVisualStyleBackColor = $True
    $update.Text = "Update"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 110
    $System_Drawing_Point.Y = 377
    $update.Location = $System_Drawing_Point 
    $update.DataBindings.DefaultDataSourceUpdateMode = 0 

    $updatenotif = New-Object System.Windows.Forms.Label

    $updatenotif.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 173
    $System_Drawing_Size.Height = 33 
    $updatenotif.Size = $System_Drawing_Size 
    $updatenotif.Text = "Update Complete!"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 97
    $System_Drawing_Point.Y = 355
    $updatenotif.Location = $System_Drawing_Point 
    $updatenotif.DataBindings.DefaultDataSourceUpdateMode = 0 

    

    $update.add_Click({
    $updatenotif.Text = "Updating..."
    $window.Controls.Add($updatenotif)
    sleep -Seconds 1
        echo "Scanner Software Path=$($scanpathtext.text)
Trading Software Path=$($tradepathtext.text)
Trade Logging Path=$($ltpathtext.text)
Screenshots Folder Path=$($scpathtext.text)
Chat Software Path=$($chatpathtext.text)" > $filepath\Config
    $updatenotif.Text = "Update Complete!"
    $window.Controls.Add($updatenotif)

    })

    #Add Buttons
    $window.Controls.Add($scpathbrowse)
    $window.Controls.Add($scpathtext)
    $window.Controls.Add($scpathlabel)
    $window.Controls.Add($scanpathtext)
    $window.Controls.Add($scanpathbrowse)
    $window.Controls.Add($scanpathlabel)
    $window.Controls.Add($tradepathtext)
    $window.Controls.Add($tradepathbrowse)
    $window.Controls.Add($tradepathlabel)
    $window.Controls.Add($ltpathtext)
    $window.Controls.Add($ltpathbrowse)
    $window.Controls.Add($ltpathlabel)
    $window.Controls.Add($chatpathtext)
    $window.Controls.Add($chatpathbrowse)
    $window.Controls.Add($chatpathlabel)

    $window.Controls.Add($update)

    #Save the initial state of the form 
    $InitialFormWindowState = $window.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $window.add_Load($OnLoadForm_StateCorrection) 
    #Show the Form 
    $window.ShowDialog()| Out-Null

}
GenerateForm
})
#
# editionToolStripMenuItem
#
#
$window.Controls.Add($MS_Main)
$window.icon = "$filepath\functions\refs\stocktickerboard.ico"
$window.MainMenuStrip = $MS_Main
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 

    #############################################################################
    #Provide Custom Code for events specified in PrimalForms. 
    $TIscript = { 

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

            $tipath = (((gc $filepath\Config).Split(0)[0]).Split('=')[1])

            if (($tipath) -eq "$null") {
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
            $label.Text = "You don't have this button configured!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {

        #TODO: Place custom script here
        $scandir = (Split-Path ((gc $filepath\Config).Split(0)[0]).Split('=')[1])
        $scanpath = (((gc $filepath\Config).Split(0)[0]).Split('=')[1])
        Start-Process -FilePath $scanpath -WorkingDirectory $scandir NorthAmerica.xml
        }
        }
        }

    #############################################################################

    $STscript = {
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

            $stpath = (((gc $filepath\Config).Split(1)[1]).Split('=')[1])

            if (($stpath) -eq "$null") {
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
            $label.Text = "You don't have this button configured!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {

        Start-Process ((gc $filepath\Config).Split(1)[1]).Split('=')[1]
        }
        }
        }

    #############################################################################
    $NLscript = {
            if (Get-Command debian -ErrorAction SilentlyContinue){
               
               start-process -filepath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
 & "$filepath\functions\NLterminal-DEBIAN.ps1" } 
            } else {

              
               start-process -filepath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
 & "$filepath\functions\NLterminal-POWERSHELL.ps1" } 
              }              
             
             }
             

    ###########################################################

    $Chatscript = {
       
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

            $chatpath = (((gc $filepath\Config).Split(4)[4]).Split('=')[1])

            if (($chatpath) -eq "$null") {
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
            $label.Text = "You don't have this button configured!`n`nPlease go to Settings -> Configure in the main menu."
            $label.Location = New-Object System.Drawing.Size(25,25)
            $label.height = 100
            $label.width = 250

            $window.Controls.add($label)
            $window.Controls.Add($window)
            $window.ShowDialog()

            } else {

        Start-Process ((gc $filepath\Config).Split(4)[4]).Split('=')[1]
        }
        }
        

    }


    #################################################################
    $MNscript = {
 <#   if (Get-Command  debian -ErrorAction SilentlyContinue){
               start-process -filepath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
 & "$filepath\functions\MN-DEBIAN.ps1" } -windowstyle hidden
 } else {
 #>   start-process -filepath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
 & "$filepath\functions\MN-POWERSHELL.ps1" } -windowstyle hidden
 #}
        }
        #################################################################
    $LTscript={

               start-process -filepath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
 & "$filepath\functions\LT.ps1" } -windowstyle hidden

    }
    #####################################################################

    $OnLoadForm_StateCorrection = {
        #Correct the initial state of the form to prevent the .Net maximized form issue 
        $window.WindowState = $InitialFormWindowState 
    }
    #---------------------------------------------- 
    #region Generated Form Code 
 #   $window.Text = "Trading Companion" 
    #$window.Name = "Say Hi..." 
    $window.DataBindings.DefaultDataSourceUpdateMode = 0 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 190
    $System_Drawing_Size.Height = 275
    $window.ClientSize = $System_Drawing_Size
 #   $MS_Main.StartPosition = 4
 $window.BackColor = '#D1D0CE'
 #$window.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
 
     #Chatroom Button
    $Chatbutton.TabIndex = 0
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 160 
    $System_Drawing_Size.Height = 23 
    $Chatbutton.Size = $System_Drawing_Size 
    $Chatbutton.UseVisualStyleBackColor = $True
    $Chatbutton.Text = "Open Chatroom Software"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 35
#    $Chatbutton.AutoSize = $True
    $Chatbutton.Location = $System_Drawing_Point 
    $Chatbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $Chatbutton.add_Click($Chatscript)



    #TradeIdeas Button
    $TIbutton.TabIndex = 0
    $TIbutton.Name = "Open Scanning Softwares" 
    $TIbutton.Size = $System_Drawing_Size 
    $TIbutton.UseVisualStyleBackColor = $True
    $TIbutton.Text = "Open Scanning Software"
    $System_Drawing_Point.X = 13 
    $System_Drawing_Point.Y = 75
    $TIbutton.Location = $System_Drawing_Point 
    $TIbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $TIbutton.add_Click($TIscript)

    #Suretrader Button
    $STbutton.TabIndex = 0
    $STbutton.Size = $System_Drawing_Size 
    $STbutton.UseVisualStyleBackColor = $True
    $STbutton.Text = "Open Trading Software"
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 115
#    $STbutton.AutoSize = $True
    $STbutton.Location = $System_Drawing_Point 
    $STbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $STbutton.add_Click($STscript)

    #NewsLink Button
    $NLbutton.TabIndex = 0
    $NLbutton.Size = $System_Drawing_Size 
    $NLbutton.UseVisualStyleBackColor = $True
    $NLbutton.Text = "Open NewsLink"
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 155
    $NLbutton.Location = $System_Drawing_Point 
    $NLbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $NLbutton.add_Click($NLscript)

    #Morning News Button
    $MNbutton.TabIndex = 0
    $MNbutton.Size = $System_Drawing_Size 
    $MNbutton.UseVisualStyleBackColor = $True
    $MNbutton.Text = "Open News Scanner"
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 195
    $MNbutton.Location = $System_Drawing_Point 
    $MNbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $MNbutton.add_Click($MNscript)

    #Log Trades Button
    $LTbutton.TabIndex = 0
    $LTbutton.Size = $System_Drawing_Size 
    $LTbutton.UseVisualStyleBackColor = $True
    $LTbutton.Text = "Log Trades"
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 235
    $LTbutton.Location = $System_Drawing_Point 
    $LTbutton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $LTbutton.add_Click($LTscript)

   

    #Add Buttons
    $window.Controls.Add($TIbutton)
    $window.Controls.Add($STbutton)
    $window.Controls.Add($NLbutton)
    $window.Controls.Add($MNbutton)
    $window.Controls.Add($LTbutton)
    $window.Controls.Add($Chatbutton)

<#    $window.controls.Add($MS_Main)
    $window.Controls.Add($Settings)
    $window.Controls.Add($Configuration)
    #>


    #Endregion Generated Form Code

    #Save the initial state of the form 
    $InitialFormWindowState = $window.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $window.add_Load($OnLoadForm_StateCorrection) 
    #Show the Form 
    $window.ShowDialog()| Out-Null

} #End Function
#Call the Function 
#if ((Get-Command -Name debian) -ne "$null"){
 #if (1 -eq 1) {
 #GenForm
#} else {
GenerateForm
#}

