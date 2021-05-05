#[System.Console]::BufferWidth = 3000
Set-ExecutionPolicy -Scope CurrentUser Bypass

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#powershell {$filepath = (Get-Item -Path .\ -Verbose).FullName
#& "$filepath\functions\MAIN.ps1"}
function GenForm {
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
cd $filepath
 
    $window = New-Object System.Windows.Forms.Form 
    $label = New-Object System.Windows.Forms.Label
    $filepath = (Get-Item -Path .\ -Verbose).FullName
    $window.StartPosition = 4
    $window.Text = "Install Debian"
    $window.Name = "Say Hi..." 
    $window.DataBindings.DefaultDataSourceUpdateMode = 0 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 500
    $System_Drawing_Size.Height = 80
    $window.ClientSize = $System_Drawing_Size
    $window.icon = "$filepath\functions\refs\stocktickerboard.ico"

            $label.TabIndex = 0
            $System_Drawing_Size = New-Object System.Drawing.Size 
            $System_Drawing_Size.Width = 450
            $System_Drawing_Size.Height = 25 
            $label.Size = $System_Drawing_Size 
            $label.Text = "It looks like you don't have Debian installed on your pc. This program runs simple linux commands for better performance. Would you like to download it?" 
            $System_Drawing_Point = New-Object System.Drawing.Point 
            $System_Drawing_Point.X = 13 
            $System_Drawing_Point.Y = 13
            $label.Location = $System_Drawing_Point 
            $label.DataBindings.DefaultDataSourceUpdateMode = 0 

    $fastbutton = New-Object System.Windows.Forms.Button
    $slowbutton = New-Object System.Windows.Forms.Button

    $fastbutton.TabIndex = 0
    $fastbutton.Name = "I want speed" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 90
    $System_Drawing_Size.Height = 23 
    $fastbutton.Size = $System_Drawing_Size 
    $fastbutton.UseVisualStyleBackColor = $True
    $fastbutton.Text = "I want speed"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 75
    $System_Drawing_Point.Y = 50
    $fastbutton.Location = $System_Drawing_Point 
    $fastbutton.DataBindings.DefaultDataSourceUpdateMode = 0 

    $slowbutton.TabIndex = 0
    $slowbutton.Name = "I'll stay slow" 
    $System_Drawing_Size = New-Object System.Drawing.Size 
    $System_Drawing_Size.Width = 90
    $System_Drawing_Size.Height = 23 
    $slowbutton.Size = $System_Drawing_Size 
    $slowbutton.UseVisualStyleBackColor = $True
    $slowbutton.Text = "I'll stay slow"
    $System_Drawing_Point = New-Object System.Drawing.Point 
    $System_Drawing_Point.X = 295
    $System_Drawing_Point.Y = 50
    $slowbutton.Location = $System_Drawing_Point 
    $slowbutton.DataBindings.DefaultDataSourceUpdateMode = 0 

    $debiandownload={
    $window.Dispose()


    Start-Process powershell -Verb runas {if ((Get-WindowsOptionalFeature -FeatureName 'Microsoft-Windows-Subsystem-Linux' -Online | select state | Out-String -Stream | select -Skip 3) -eq 'Enabled') {} else { Write-Host 'Please allow installation. This will take 10 seconds. DO NOT CLOSE ANY WINDOWS.'; Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'}}
    


    if ((gc $filepath\deb -ErrorAction SilentlyContinue) -eq "0"){

    while (1 -eq 1){
    $yn = Read-Host "Have you restarted your computer since initially starting this program? Y/N"
    if ($yn -eq "N"){
    Read-Host "Please retry after you have restarted your computer."
    exit
    } elseif ($yn -eq "Y"){
        
        start https://www.microsoft.com/en-us/p/debian/9msvkqc78pk6

        write-host "Install Debian from the App store. DO NOT CLOSE THIS WINDOW."

        while (([bool](Get-Command -Name debian.exe -ErrorAction SilentlyContinue)) -eq $False){
        Write-Host -ForegroundColor Red  "Waiting..."
        sleep -Seconds 2   
        Write-Host -ForegroundColor Red  "Waiting..."
        sleep -Seconds 2
        Write-Host -ForegroundColor Red  "Waiting..."
        sleep -Seconds 2
        clear
        write-host "Install Debian from the App store. DO NOT CLOSE THIS WINDOW."
        echo "1" > $filepath\deb
        }
        break
        } else {
            Write-Host "Unexpected response..."
            sleep 3
            }
            
        }
     
     }




    if ((Get-Command debian -ErrorAction SilentlyContinue)) {


$filepath = (Get-Item -Path .\ -Verbose).FullName


if ((gc $filepath\deb -ErrorAction SilentlyContinue) -eq "1"){
    

    Write-Host "Please follow the prompt within Debian and finish the install."

    Start-Process debian.exe

    rm $filepath\deb

    
    sleep -Seconds 2

    Read-Host "Press ENTER when complete and REOPEN THE PROGRAM."


    exit

    }

        

        write-host "Setting up Linux..."
        sleep -Seconds 2
        write-host "Please allow a couple minutes for the install and input your debian password when prompted."
        sleep -Seconds 2


    if((debian run command -v html2text | Out-String) -eq "$null"){
        debian run sudo apt-get update        
        debian run sudo apt-get install html2text
        sleep -Seconds 1
        }
    if((debian run command -v curl | Out-String) -eq "$null"){ 
        debian run sudo apt-get update        
        debian run sudo apt-get install curl
        sleep -Seconds 1
        echo "Install Complete."
        sleep -Seconds 4
 
       
 }       


Start-Process -FilePath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
& "$filepath\functions\MAIN.ps1"} -windowstyle hidden





} else {
 echo "0" > $filepath\deb
 GenForm
}

}
    $fastbutton.add_Click($debiandownload)

    $continuebutton={
    $window.Dispose()
    Start-Process -FilePath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
& "$filepath\functions\MAIN.ps1"} -windowstyle hidden
}

    $slowbutton.add_Click($continuebutton)
    
    $window.Controls.Add($fastbutton)
    $window.Controls.Add($slowbutton)
    $window.Controls.Add($label)
    #Save the initial state of the form 
    $InitialFormWindowState = $window.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $window.add_Load($OnLoadForm_StateCorrection) 
    #Show the Form 
    $window.ShowDialog()| Out-Null
}
    if ((Get-Command debian -ErrorAction SilentlyContinue)) {


$filepath = (Get-Item -Path .\ -Verbose).FullName


if ((gc $filepath\deb -ErrorAction SilentlyContinue) -eq "1"){
    
    clear

    Write-Host "Please follow the prompt within Debian and finish the install."

    Start-Process debian.exe

    rm $filepath\deb

    
    sleep -Seconds 2

    Read-Host "Press ENTER when complete and REOPEN THE PROGRAM (An Error Message is normal)."


    exit

    }

    if(((debian run command -v html2text | Out-String) -or (debian run command -v curl | Out-String)) -eq "$null"){

        write-host "Setting up Linux..."
        sleep -Seconds 2
        write-host "Please allow a couple minutes for the install and input your debian password when prompted."
        sleep -Seconds 2


    if((debian run command -v html2text | Out-String) -eq "$null"){
        debian run sudo apt-get update
        debian run sudo apt-get install html2text
        sleep -Seconds 1
        }
    if((debian run command -v curl | Out-String) -eq "$null"){  
        debian run sudo apt-get update     
        debian run sudo apt-get install curl
        sleep -Seconds 1
        echo "Install Complete."
        sleep -Seconds 4
 
       
 }       
 }

Start-Process -FilePath "powershell" {$filepath = (Get-Item -Path .\ -Verbose).FullName
& "$filepath\functions\MAIN.ps1"} -windowstyle hidden



} else {
$filepath = (Get-Item -Path .\ -Verbose)

cd $filepath

if (Test-Path "$filepath\screenshots\1"){
write-host "Creating Desktop Shortcut..."
$targetfile = "$filepath\Trading_Companion_V2.3.exe"
$shortcutfile = "$env:USERPROFILE\Desktop\Trading Companion.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutFile)
$shortcut.TargetPath = $targetfile
$shortcut.IconLocation = "$filepath\functions\refs\stocktickerboard.ico"
$shortcut.WorkingDirectory = $filepath
sleep -Seconds 3
$shortcut.Save()
rm "$filepath\screenshots\1"
}

GenForm

}