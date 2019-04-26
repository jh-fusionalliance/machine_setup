Import-Module -Force "$(split-path -parent $MyInvocation.MyCommand.Definition)\admin.psm1";

$NNumber = "";
$EmailAddress = "";
$tempDir = "C:\Temp\dna";
$lmigChegRepo = "https://chefrepo.lmig.com/lm_eclipse";
$eclipsePluginsDir = "C:\Program Files\Eclipse 4.9\eclipse\plugins";
$eclipsePlugins = @(
    "buildship_gradle_integration_2.0.zip",
    "org.dadacoalition.yedit_1.0.20.201509041456-RELEASE.zip",
    "net.sf.eclipsecs-updatesite_7.3.0.201612142232.zip",
    "spring_tool_suite_for_eclipse_3.8.3.release.zip",
    "sonarlint_plugin.zip"
);
$software = "Docker";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

function Show-Menu {
    Clear-Host;

    Write-Host "================ DNA Setup Script ================" -ForegroundColor Cyan;
    Write-Host " Press '1' to install standard packages           [git, nodejs, yarn, jdk8, gradle, nvm, eclipse, vscode, python]" -ForegroundColor Cyan;
    Write-Host " Press '2' to uninstall standard packages         [git, nodejs, yarn, jdk8, gradle, nvm, eclipse, vscode, python]" -ForegroundColor Cyan;
    Write-Host " Press '3' to install additional software         [IntelliJ IDE, DB Visulizer, Notepad++, Postman]" -ForegroundColor Cyan;
    Write-Host " Press '4' to uninstall additional software       [IntelliJ IDE, DB Visulizer, Notepad++, Postman]" -ForegroundColor Cyan;
    Write-Host "==================================================" -ForegroundColor Cyan;
    Write-Host " Press 'Q' to quit." -ForegroundColor Red;
    Write-Host " ";
}

function Display-Message($message) {
    Clear-Host

    $lines = ''

    for ($i = 0; $i -lt $message.length; $i++) {
        $lines += "="
    }

    Write-Output $lines"`n"
    Write-Output $message"`n"
    Write-Output $lines"`n"
}

function Pre-Check {
    # Fail out of script if not running it from a location on C:\
    If (-NOT ((Get-Location).Drive.name).Equals("C")) {
        Write-Warning "This script must be run from a location on your C: Drive!`nPlease place this script on your C: drive and run it from there."
        Pause
        Break
    }
}

function Promt-User {
    #Get n number
    $script:NNumber = Read-Host -Prompt "Enter your n number"

    #Get First and Last Name
    $script:FullName = Read-Host -Prompt "Enter your first and last name"

    #Get Email Address
    $script:EmailAddress = Read-Host -Prompt "Enter your email address"

    Clear-Host
}

function Set-Git {
    Write-Output "======================`n"
    Write-Output "Stage: Configuring Git`n"
    Write-Output "======================`n"

    # Set Git autocrlf
    $GitAutocrlf = "config --global core.autocrlf true"

    #Write-Host GitAutocrlf: $GitAutocrlf
    & 'cmd.exe' /C "C:\Progra~1\Git\cmd\git.exe $GitAutocrlf"

    # Set Git User Name
    $GitUserName = "config --global user.name `"$FullName`""

    #Write-Host GitUserName: $GitUserName
    & 'cmd.exe' /C "C:\Progra~1\Git\cmd\git.exe $GitUserName"

    # Set Git Email Address
    $GitEmailAddress = "config --global user.email $EmailAddress"

    #Write-Host GitEmailAddress: $GitEmailAddress
    & 'cmd.exe' /C "C:\Progra~1\Git\cmd\git.exe $GitEmailAddress"
}

function Install-Eclipse-Plugins {
    Write-Output "==============================`n"
    Write-Output "Stage: Creating temp directory`n"
    Write-Output "==============================`n"

    New-Item -ItemType directory -Path "C:\Temp\dna" -Force

    Foreach ($plugin in $eclipsePlugins) {
        $lines = ''
        for ($i = 0; $i -lt $message.length; $i++) {
            $lines += "="
        }

        Write-Output $lines
        Write-Output 'Stage: Installing '$plugin;
        Write-Output $lines

        Invoke-WebRequest -Uri $lmigChegRepo'/'$plugin -OutFile $tempDir'\'$plugin
        Copy-Item -Path $tempDir'\'$plugin -Destination $eclipsePluginsDir'\'$plugin
        Expand-Archive -LiteralPath $eclipsePluginsDir'\'$plugin -DestinationPath $eclipsePluginsDir -Force
        Remove-Item -Path $eclipsePluginsDir'\'$plugin -Force
    }
}

function Install-Python-Scripts {
    Write-Output "=====================================`n"
    Write-Output "Stage: Installing windows build tools`n"
    Write-Output "=====================================`n"

    npm install --global --production windows-build-tools
    npm install --global node-gyp
}

function Install-Chocolatey {
    Write-Output "============================`n"
    Write-Output "Stage: Installing chocolatey`n"
    Write-Output "============================`n"

    Set-ExecutionPolicy Bypass -Scope Process; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function  InstallAdditional-Softwares {
    Install-Chocolatey

    $input = Read-Host "Would you like to install Intellij IDE (Y/N)?:"

    if ($input -eq "Y") {
        Write-Output "=================================`n"
        Write-Output "Stage: Installing Intellij IDE`n"
        Write-Output "=================================`n"

        choco install intellijidea-community -y

        Write-Output "=================================`n"
        Write-Output "Stage: Intellij IDE Installation complete. `n"
        Write-Output "=================================`n"
    }

    $input1 = Read-Host "Would you like to install Db visualizer (Y/N)?:"

    if ($input1 -eq "Y") {

        Write-Output "=================================`n"
        Write-Output "Stage: Installing Db Visualizer`n"
        Write-Output "=================================`n"

        choco install db-visualizer -y

        Write-Output "===========================================`n"
        Write-Output "Stage: Db Visualizer Installation complete. `n"
        Write-Output "===========================================`n"
    }

    $input2 = Read-Host "Would you like to install NotepadPlusPlus (Y/N)?:"

    if ($input2 -eq "Y") {

        Write-Output "=================================`n"
        Write-Output "Stage: Installing NotepadPlusPlus   `n"
        Write-Output "=================================`n"

        choco install notepadplusplus.install -y

        Write-Output "===========================================`n"
        Write-Output "Stage: NotepadPlusPlus Installation complete. `n"
        Write-Output "===========================================`n"
    }

    $input3 = Read-Host "Would you like to install Postamn (Y/N)?:"

    if ($input3 -eq "Y") {

        Write-Output "=================================`n"
        Write-Output "Stage: Installing Postman   `n"
        Write-Output "=================================`n"

        choco install postman -y

        Write-Output "===========================================`n"
        Write-Output "Stage: Postman Installation complete. `n"
        Write-Output "===========================================`n"
    }
}

function Install-Packages {
    Install-Chocolatey

    Write-Output "==========================`n"
    Write-Output "Stage: Installing packages`n"
    Write-Output "==========================`n"

    choco install git -y
    choco install nodejs --version 10.14.2 -y
    choco install nvm -y
    choco install adoptopenjdk8jre -y
    choco install gradle --version 5.0 -y
    choco install yarn -y
    choco install eclipse --version 4.9 -y
    choco install vscode -y
    choco install python -y

    If(-Not $installed) {
        Write-Output "===========================================`n"
        Write-Output "Stage: Docker isn't installed skipping. `n"
        Write-Output "===========================================`n"
    } else {
        Write-Output "===========================================`n"
        Write-Output "Stage: Docker is installed updating. `n"
        Write-Output "===========================================`n"
        Add-User
        cup docker-desktop -y
    }
}

function Uninstall-Packages {
    Install-Chocolatey

    Write-Output "============================`n"
    Write-Output "Stage: Uninstalling packages`n"
    Write-Output "============================`n"

    choco uninstall git -y
    choco uninstall nodejs --version 10.14.2 -y
    choco uninstall nvm -y
    choco uninstall adoptopenjdk8jre -y
    choco uninstall gradle --version 5.0 -y
    choco uninstall yarn -y
    choco uninstall eclipse --version 4.9 -y
    choco uninstall vscode -y
    choco uninstall python -y
}

function RunInstallAdditionalSoftwares {
    PreCheck
    PromtUser
    DisplayMessage "NOTE: Package installation could take anywhere between 15-20 minutes."
    InstallAdditional-Softwares
}

function Run-Install {
    Pre-Check
    Promt-User
    Display-Message "NOTE: Package installation could take anywhere between 15-20 minutes."
    Install-Packages
    Set-Git
    Install-Eclipse-Plugins
    #Install-Python-Scripts

    Write-Output "=========================`n"
    Write-Output "Installation is completed`n"
    Write-Output "=========================`n"
}

function RunUninstallAdditionalSoftwares {
    Install-Chocolatey

    $input = Read-Host "Would you like to UnInstall Intellij IDE (Y/N)?:"

    if ($input -eq "Y") {
        Write-Output "Stage: Unininstalling Intellij IDE`n"

        choco uninstall intellijidea-community -y

        Write-Output "Stage: Unintellij IDE Uninstallation complete. `n"
    }

    $input1 = Read-Host "Would you like to Uninstall Db visualizer (Y/N)?:"

    if ($input1 -eq "Y") {
        Write-Output "Stage: Uninstalling Db Visualizer`n"

        choco uninstall db-visualizer -y

        Write-Output "Stage: Db Visualizer Uninstallation complete.`n"
    }

    $input2 = Read-Host "Would you like to Uninstall NotepaddPlusPlus (Y/N)?:"

    if ($input2 -eq "Y") {
        Write-Output "Stage: Uninstalling NotepaddPlusPlus `n"

        choco uninstall notepadplusplus.install -y

        Write-Output "Stage: NotepaddPlusPlus Uninstallation complete.`n"
    }
    $input3 = Read-Host "Would you like to Uninstall Postman (Y/N)?:"

    if ($input3 -eq "Y") {
        Write-Output "Stage: Uninstalling Postman `n"

        choco uninstall postman -y

        Write-Output "Stage: Postman Uninstallation complete.`n"
    }

}

function Run-Uninstall {
    Display-Message "NOTE: Package uninstall could take anywhere between 10-15 minutes."
    Uninstall-Packages

    Write-Output "===========================`n"
    Write-Output "Uninstallation is completed`n"
    Write-Output "===========================`n"
}

function Add-User
{
    Add-LocalGroupMember -Group "DockerUsers" -Member lm\$NNumber
}

# This script needs to be run as Administorator
if ( RunAsAdmin($MyInvocation.MyCommand.Definition) ) {
    while ( $true ) {
        Show-Menu
        switch (Read-Host "Please make a selection") {
            '1' {
                Clear-Host
                Run-Install
            }
            '2' {
                Clear-Host
                Run-Uninstall
            }
            '3' {
                Clear-Host
                RunInstallAdditionalSoftwares
            }
            '4' {
                Clear-Host
                RunUninstallAdditionalSoftwares
            }
            'q' {
                exit
            }
        }

        Write-Output " ";
        Pause;
    }
}
else {
    Write-Output "Administrator privileges are required to run this script.";
    Pause;
}
