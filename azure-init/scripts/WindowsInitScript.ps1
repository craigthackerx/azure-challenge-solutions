#!/usr/bin/env pwsh

#Set Execution Policy
Set-ExecutionPolicy RemoteSigned -scope CurrentUser ; `

#Install Scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') ;  `

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) ; `
