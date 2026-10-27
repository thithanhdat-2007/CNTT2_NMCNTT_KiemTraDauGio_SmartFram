# AUDIT: Da tham dinh script, khong co lenh xoa hang loat.

$logFile = "../data/log-he-thong.log"
$reportFile = "../backup/bao-cao-su-co.txt"

Write-Output "BAO CAO SU CO HE THONG SMARTFARM" > $reportFile
Write-Output "NGAY GIO: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" >> $reportFile
Write-Output "" >> $reportFile

Get-Content $logFile | Select-String -Pattern "CRITICAL", "ERROR" >> $reportFile

$soSuCo = (Get-Content $logFile | Select-String -Pattern "CRITICAL", "ERROR" | Measure-Object -Line).Lines

Write-Output "" >> $reportFile
Write-Output "TONG SO SU CO:" >> $reportFile
Write-Output $soSuCo >> $reportFile

Write-Output "Da tao bao cao tai: $reportFile"