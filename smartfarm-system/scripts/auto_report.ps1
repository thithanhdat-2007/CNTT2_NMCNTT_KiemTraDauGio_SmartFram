# AUDIT: Da kiem tra script, khong co lenh xoa du lieu hang loat.

$logFile = '..\data\log-he-thong.log'
$reportFile = '..\backup\bao-cao-su-co.txt'
$pattern = '\[(ERROR|CRITICAL)\]'

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

Write-Output 'BAO CAO SU CO - SMARTFARM' > $reportFile
Write-Output "Ngay gio: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" >> $reportFile
Write-Output '========================================' >> $reportFile

Get-Content $logFile | Select-String -Pattern $pattern >> $reportFile

$soSuCo = (Get-Content $logFile | Select-String -Pattern $pattern | Measure-Object).Count
Write-Output '========================================' >> $reportFile
Write-Output 'TONG SO SU CO:' >> $reportFile
Write-Output $soSuCo >> $reportFile
