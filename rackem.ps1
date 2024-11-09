<#
.NOTES
    Author  : Aubrey Bowes
    Version : 1
    
#>
Add-Type -AssemblyName PresentationFramework

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'

<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp3"
        Title="Rackem" Height="450" Width="700">
     <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="344*"/>
            <ColumnDefinition Width="379*"/>
        </Grid.ColumnDefinitions>
        <Grid.Background>
            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                <GradientStop Color="Black" Offset="0"/>
                <GradientStop Color="#FF2C2626" Offset="1"/>
            </LinearGradientBrush>
        </Grid.Background>
        <Image HorizontalAlignment="Left" Height="202" Margin="-32,217,0,0" VerticalAlignment="Top" Width="203" Source="—Pngtree—hand-painted raccoon vector_3247284.png"/>
        <TextBox Name="tprecious" HorizontalAlignment="Left" Height="22" Margin="122,357,0,0" TextWrapping="Wrap" Text="time is precious. waste it wisely" VerticalAlignment="Top" Width="212" FontFamily="SimSun" Background="Black" BorderBrush="Black" Foreground="White"/>
        <Button Name="Start" Content="Start" HorizontalAlignment="Left" Height="37" Margin="152.216,341,0,0" VerticalAlignment="Top" Width="81" FontFamily="SimSun" FontSize="24" Background="#FFC1E0C1" Grid.Column="1"/>
        <Rectangle Name="BG1" Fill="#FFDDDDDD" HorizontalAlignment="Left" Height="153" Margin="114.216,129,0,0" Stroke="Black" VerticalAlignment="Top" Width="148" Grid.Column="1"/>
        <CheckBox Name="Cleanup" Content="Cleanup Utlities" HorizontalAlignment="Left" Margin="131.216,256,0,0" VerticalAlignment="Top" FontFamily="SimSun" Grid.Column="1"/>
        <CheckBox Name="Antivirus" Content="Antivirus Script" HorizontalAlignment="Left" Margin="131.216,233,0,0" VerticalAlignment="Top" FontFamily="SimSun" Grid.Column="1"/>
        <Expander Header="?" HorizontalAlignment="Left" Height="126" Margin="262,253,0,0" VerticalAlignment="Top" Width="100" FontFamily="SimSun" Foreground="#FF6AFF8C" Grid.Column="1" ExpandDirection="Right">
            <TextBlock TextWrapping="Wrap" Background="Black" Foreground="White" Margin="0,12,0,-32">
                This script will remove temp files, clear recycling bin and create and delete old restore points.
            </TextBlock>
        </Expander>
        <Expander Header="?" HorizontalAlignment="Left" Height="192" Margin="21,227,0,0" VerticalAlignment="Top" Width="95" Foreground="#FF6AFF8C" Grid.Column="1" ExpandDirection="Left">
            <TextBlock TextWrapping="Wrap" Background="Black" Foreground="White" FontFamily="SimSun" Margin="0,0,0,72">
                This script will run Defender scans, removing threats if found.
            </TextBlock>
        </Expander>
        <TextBox Name="Version" HorizontalAlignment="Left" Height="23" Margin="10,10,0,0" TextWrapping="Wrap" Text="Version 1" VerticalAlignment="Top" Width="120" Background="{x:Null}" Foreground="White" FontFamily="SimSun" BorderBrush="{x:Null}"/>
        <Rectangle Fill="#FFDDDDDD" HorizontalAlignment="Left" Height="153" Margin="197,129,0,0" Stroke="Black" VerticalAlignment="Top" Width="148" RenderTransformOrigin="1.102,0.53" Grid.ColumnSpan="2"/>
        <CheckBox Name="UninstBloat" Content="Uninstall Bloat" HorizontalAlignment="Left" Margin="211,142,0,0" VerticalAlignment="Top" FontFamily="SimSun"/>
        <TextBlock Name="UninstallExplain" HorizontalAlignment="Left" Margin="211,173,0,0" TextWrapping="Wrap" Text="Uninstalls many applications that are installed by default with Win11 Machines." VerticalAlignment="Top" FontFamily="SimSun" Height="98" Width="123"/>
        <Rectangle Fill="#FFDDDDDD" HorizontalAlignment="Left" Height="63" Margin="197,36,0,0" Stroke="Black" VerticalAlignment="Top" Width="394" RenderTransformOrigin="1.102,0.53" Grid.ColumnSpan="2"/>
        <CheckBox Name="AIO" Content="All in One" HorizontalAlignment="Left" Margin="211,47,0,0" VerticalAlignment="Top" FontFamily="SimSun"/>
        <TextBlock Name="AIOExplain" HorizontalAlignment="Left" Margin="72,46,0,0" TextWrapping="Wrap" Text="Preps system, cleans, deboats, disinfects, repairs, patches, and optimizes. " VerticalAlignment="Top" Height="49" Width="181" FontFamily="SimSun" Grid.Column="1"/>
        <CheckBox Name="ThirdPtyTools" Content="Include 3rd Party Tools" HorizontalAlignment="Left" Margin="211,70,0,0" VerticalAlignment="Top" FontFamily="SimSun" Grid.ColumnSpan="2"/>

    </Grid>
</Window>
'@
try {
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Window = [Windows.Markup.XamlReader]::Load($reader)
}catch {
    Write-Host "Error loading XAML: $_"
    Start-Sleep -Seconds 10
    exit
}

if ($null -eq $Window) {
    Write-Host "Window is null after loading XAML."
    Start-Sleep Seconds 10
    exit
}
function PrepStage {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
    # Set description and restore point type
    $Date = Get-Date

    try {
        Checkpoint-Computer -Description "($Date) Restore Point" -RestorePointType "APPLICATION_INSTALL"
    } catch {
        Write-Output "An error occured: $_"
    }
}

function Cleanup {
        $temppath = "$env:Temp\*"
        try {
            Write-Host "Clearing Temporary Files..."
            Remove-Item $temppath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Temporary files cleared."
            Start-Sleep -Seconds 1
        } catch {
            Write-Host "Couldn't eat $_"
        }  
        Write-Host "Emptying recycling bin.."
        Start-Sleep -Seconds 1
        try {
        Get-ChildItem -Force -LiteralPath 'C:\$RECYCLE.BIN' | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Recycle bin emptied."
        Start-Sleep -Seconds 1
        } catch {
            Write-Host "Couldn't eat $_"
        }
        Write-Host "Eating Windows Update cache..."
        Start-Sleep -Seconds 1
        try {
        $windowsUpdateCache = "C:\Windows\SoftwareDistribution\Download*"
        Remove-Item $windowsUpdateCache -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Windows Update cache eaten."
        Start-Sleep -Seconds 1
        } catch {
            Write-Host "Couldn't eat $_"
        }
        Write-Host "Clearing your old restore points..."
        Start-Sleep -Seconds 1
        $restorePoints = Get-ComputerRestorePoint | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-3) }
       
        if ($restorePoints.Count -eq 0) {
            Write-Host "No restore points old enough to remove."
            Start-Sleep -Seconds 1  
        } else {
           foreach ($point in $restorePoints) {
            try {
                # Only remove restore points that are older than thirty days
                vssadmin delete shadows /shadow={($point.ShadowId)} /quiet
                Write-Host "Old restore point on $(point.CreationTime) has been eaten."
                Start-Sleep -Seconds 1
            } catch {
                Write-Host "Could not eat.. $_"
            }
            }
        }
        Write-Host "Eating Browser caches..."
        $chromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"
        Remove-Item $chromeCachePath -Recurse -Force -ErrorAction SilentlyContinue
        $firefoxCachePath = "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2\*"
        Remove-Item $firefoxCachePath -Recurse -Force -ErrorAction SilentlyContinue
        $floorpCachePath = "$env:APPDATA\Floorp\Profiles\*\cache2\*"
        Remove-Item $floorpCachePath
        $zenCachePath = "$env:APPDATA\Zen\Profiles\*\cache2\*"
        Remove-Item $zenCachePath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Browser Caches eaten."
        
        Write-Host "Starting Disk Cleanup..."
        $cleanmgrPath = "$env:SystemRoot\System32\cleanmgr.exe"
        Start-Process $cleanmgrPath -ArgumentList "/sagerun:1" | Out-Null
        Start-Sleep -Seconds 5
        Write-Host "Disk Cleanup Completed" -Foregroundcolor Green
    }

    # A Function is a reusable block of code that performs a specific task. In this case, functions are uninstalling specific AppxPackages.
function DeBloat {
    # Notifies user that OneDrive uninstallation has started
    Write-Host "Uninstalling Bloatware..."
    # Stalls the application for a second, allowing user to read.
    Start-Sleep -Seconds 1
    # Try and catch statements for error handling. It will execute the code, and any errors will prompt the catch { } cmdlet and code internally will be ran.
    # If no error, catch will not be triggered and code will be bypassed.
    try {
        # Get-AppxPackage: Gets a list of packages installed in a user profile
        # *OneDrive*, * being a wildcard representing 0 or more characters, filters through the list and only outputs applications with "Onedrive" in the name.
        # | Pipe, takes the output of Get-AppxPackage *OneDrive* and uses it as the Input for Remove-AppXPackage
        # Remove-AppxPackage: Removes the app package for all user accounts on the computer
        Get-AppxPackage *OneDrive* | Remove-AppxPackage
    } catch {
        # $_ is a special variable that for this context within the catch clock will represent the current error object. 
        # That way, it will output what the error is. 
        Write-Host "Couldn't uninstall:$_"
        # The shell will stall for ten seconds, allowing the user to access the error. 
        Start-Sleep -Seconds 10
    }
    try {
        Get-AppxPackage *Microsoft.XboxGamingOverlay* | Remove-AppxPackage -AllUsers
    } catch {
    Write-Host "Couldn't eat: $_"
    }
    Start-Sleep -Seconds 1
    try {
        Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage -AllUsers
        Start-Sleep -Seconds 1
    } catch {
        Write-Host "Couldn't eat: $_"
        Start-Sleep -Seconds 10
    }
    try {
        Get-AppxPackage *ZuneMusic* | Remove-AppxPackage -AllUsers
        Start-Sleep -Seconds 1
    } catch {
        Write-Host "Couldn't eat:$_"
        Start-Sleep -Seconds 10
    }
    try {
        Get-AppxPackage *WindowsCamera* | Remove-AppxPackage -AllUsers
        Start-Sleep -Seconds 1
    } catch {
        Write-Host "Couldn't eat:$_"
        Start-Sleep -Seconds 10
    }
    Write-Output "Bloatware has been uninstalled or disabled."
}

function Repairs {
    Write-Host "Checking and repairing disk errors..."
    sfc /scannow
    DISM /Online /Cleanup-Image /-RestoreHealth
    Repair-Volume -DriveLetter C -Scan
    Repair-FileIntegrity -DriveLetter C
    Repair-WindowsImage -Online -CheckHealth
    if ($?){
        Write-Host "Repairing Windows Image..."
        Repair-WindowsImage -Online -RestoreHealth
    }
    Write-Host "Repair operations completed." 
}

function Optimize {
    Write-Host "Defragmenting the hard drive..."
    try {
        Optimize-Volume -DriveLetter C -ReTrim -Verbose
        Write-Output "Drive C: optimized."
    }catch{
        Write-Output "Defrag failed: $_"
    }
    try {
        Write-Output "Setting power plan to high performance..."
        powercfg -setactive SCHEME_MAX
    } catch {
        Write-Output "Failed to set power settings: $_"
    }
    try {
        $regPath = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value "2" 
        Write-Output "Visual effects configured for performance."
    } catch {
        Write-Output "Failed to configure visual settings: $_"
    }
    Write-Host "Optimize stage is complete."
}
function DefenderScan {
    Write-Host "Starting a full system scan for evil trash using Microsoft Defender..."
    Start-MpScan -ScanPath "C:\" -AsJob -ScanType FullScan 
    Write-Host "Scan started.. please wait for completion..."
    if ($threats) {
        Write-Host "Detected threats $threats found. Eating..."
        Remove-MpThreat 
        Write-Host "Threats $threats eaten."
    } else {
        Write-Host "No threats found to eat."
    }
    
}

function ThirdPtyTools {
    Write-Output "Checking if winget is installed..."
    if (-not $wingetInstalled) {
        # Install winget
        Write-Host "Installing winget..."
        Install-Script -Name winget-install -RequiredVersion 2.1.0 -Force
        Write-Host "winget installation complete."
    }
    Write-Output "Installing Translucent TB..."
    winget install --id "Translucent.TB.TranslucentTB" 
}


$AIOCheckbox = $Window.FindName("AIO")
$ThirdPtyToolsCheckbox = $Window.FindName("ThirdPtyTools")
$CleanupCheckbox = $Window.FindName("Cleanup")
$UninstBloatCheckbox = $Window.FindName("UninstBloat")
$AntivirusCheckbox = $Window.FindName("Antivirus")

# Run selected functions on Start button click
$Start = $Window.FindName("Start")
$Start.Add_Click({
    Write-Host "This button works!"
    Write-Host "Start button clicked, running selected functions."
    if ($AIOCheckbox.IsChecked) {
    Write-Host "Running PrepStage"; PrepStage 
    Write-Host "Running Cleanup"; Cleanup 
    Write-Host "Running DefenderScan"; DefenderScan 
    Write-Host "Running DeBloat"; DeBloat 
    Write-Host "Running Repairs"; Repairs 
    Write-Host "Running Optimize"; Optimize 
     }
    if ($ThirdPtyToolsCheckbox.IsChecked) { Write-Host "Running ThirdPtyTools"; ThirdPtyTools }
    if ($CleanupCheckbox.IsChecked) { Write-Host "Running Cleanup"; Cleanup }
    if ($AntivirusCheckbox.IsChecked) { Write-Host "Running Defender"; DefenderScan }
    if ($UninstBloatCheckbox.IsChecked) { Write-Host "Running DeBloat"; DeBloat }
})

$Window.ShowDialog() | Out-Null