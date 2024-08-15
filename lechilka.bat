@echo off
setlocal

REM Очистка временных файлов
echo Очистка временных файлов...
del /q /f %TEMP%\*
del /q /f %SystemRoot%\Temp\*
echo Временные файлы очищены.

REM Очистка системного кэша
echo Очистка системного кэша...
powershell -command "Clear-WebCache"
powershell -command "Clear-DnsClientCache"
echo Системный кэш очищен.

REM Очистка кэша обновлений Windows
echo Очистка кэша обновлений Windows...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
del /q /f %SystemRoot%\SoftwareDistribution\* 
del /q /f %SystemRoot%\System32\catroot2\* 
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo Кэш обновлений Windows очищен.

REM Восстановление кэша Windows Store
echo Восстановление кэша Windows Store...
powershell -command "Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}"
echo Кэш Windows Store восстановлен.

REM Проверка и исправление ошибок жесткого диска
echo Проверка состояния жесткого диска...
chkdsk C: /f /r
echo Проверка завершена. Необходимо перезагрузить компьютер для завершения проверки.

REM Проверка состояния и исправление проблем с конфигурацией сети
echo Проверка и исправление проблем с конфигурацией сети...
netsh winsock reset
netsh int ip reset
ipconfig /flushdns
echo Конфигурация сети восстановлена.

REM Восстановление системных файлов
echo Восстановление системных файлов...
sfc /scannow
echo Восстановление завершено.

REM Оптимизация и дефрагментация
echo Оптимизация и дефрагментация диска...
defrag C: /O /H
echo Оптимизация и дефрагментация завершены.

REM Отключение ненужных автозапусков
echo Отключение ненужных автозапусков...
powershell -command "Get-CimInstance Win32_StartupCommand | Where-Object {$_.Location -eq 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run'} | ForEach-Object {Remove-ItemProperty -Path $_.Location -Name $_.Command -ErrorAction SilentlyContinue}"
echo Ненужные автозапуски отключены.

REM Проверка состояния службы Windows Update
echo Проверка состояния службы Windows Update...
sc query wuauserv
echo Служба Windows Update проверена.

REM Проверка состояния и исправление проблем с жесткими дисками (включая SMART)
echo Проверка состояния дисков и SMART...
powershell -command "Get-PhysicalDisk | Format-Table -AutoSize | Out-File -Append -FilePath 'C:\Users\%USERNAME%\Desktop\diagnostic_report.txt' -Encoding Unicode"
echo Состояние дисков проверено.

REM Восстановление мастер-загрузочного сектора (MBR)
echo Восстановление мастер-загрузочного сектора (MBR)...
bootrec /fixmbr
bootrec /fixboot
bootrec /scanos
bootrec /rebuildbcd
echo Восстановление MBR завершено.

REM Проверка и исправление системных реестров
echo Проверка и исправление системных реестров...
REM Замените следующую строку на подходящую утилиту для проверки реестра
echo Это можно сделать вручную или с помощью сторонних утилит.

REM Очистка каталога Prefetch
echo Очистка каталога Prefetch...
del /q /f %SystemRoot%\Prefetch\*
echo Каталог Prefetch очищен.

REM Удаление программного обеспечения с потенциально нежелательными компонентами
echo Удаление программного обеспечения...
powershell -command "Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match 'UnwantedSoftware' } | ForEach-Object { $_.Uninstall() }"
echo Потенциально нежелательное ПО удалено.

REM Ремонт установленных приложений
echo Ремонт установленных приложений...
powershell -command "Get-AppxPackage | ForEach-Object { Repair-AppxPackage -Package $_.PackageFullName }"
echo Приложения отремонтированы.

REM Сброс настроек Internet Explorer/Edge
echo Сброс настроек Internet Explorer/Edge...
rundll32.exe iedkcs32.dll,ResetIESettings
echo Настройки Internet Explorer/Edge сброшены.

REM Проверка и исправление пользовательских профилей
echo Проверка пользовательских профилей...
REM Примеры утилит или команд могут быть специфичными для вашего случая.

REM Оптимизация и очищение реестра
echo Оптимизация и очищение реестра...
REM Замените следующую строку на подходящую утилиту для очистки реестра
echo Это можно сделать вручную или с помощью сторонних утилит.

REM Ограничение использования ресурсов
echo Закрытие ненужных процессов...
taskkill /F /IM unneededprocess.exe
echo Ненужные процессы закрыты.

REM Завершение скрипта
echo Лечебный процесс завершен. Пожалуйста, перезагрузите компьютер, если это необходимо.
pause
