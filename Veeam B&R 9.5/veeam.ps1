param($1,$2)
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
Add-PSSnapin VeeamPSSnapin

# Автообнарежение задач
# Ключ: discovery
if ($1 -eq "discovery") {
    try {
       $items = Get-VBRJob | ForEach-Object id
       $tempstr = "{"
       $tempstr = $tempstr + "`"data`":["
       $n = 0
       foreach ($item in $items) {
          $n = $n + 1
          $line = "{`"{#JOBID}`":`"" + ($item) + "`""
          If ($n -le $items.count) {$line = $line + ","}
          $line = $line + "`"{#JOBNAME}`":`"" + (Get-VBRJob | Where-Object id -eq $item | ForEach-Object Name) + "`"}"
          If ($n -lt $items.count) {$line = $line + ","}
          $tempstr = $tempstr + $line
       }
       $tempstr = $tempstr + "]"
       $tempstr = $tempstr + "}"
       $obj = $tempstr
    }
    catch {write-host $error;exit}
}

# Получение информации о задачах
# Ключи: 
else {
    try {
       # Ключ status – получение статуса задачи
       if ($2 -eq "status") {
          $obj = Get-VBRBackupSession | Where-Object jobid -eq $1 | Sort-Object EndTime -Descending | Select-Object -First 1 | ForEach-Object Result
       }
       # Ключ count – получение количества точек восстановления
       elseif ($2 -eq "count") {
          $obj = Get-VBRBackup | Where-Object jobid -eq $1 | Get-VBRRestorePoint | Group-Object -Property VmName | ForEach-Object Count
       }
       # Ключ last – получение даты последнего удаччного выполнения задачи
       elseif ($2 -eq "last") {
        $obj = Get-VBRBackupSession | Where-Object jobid -eq $1 | Where-Object result -eq 'Success' | Sort-Object EndTime -Descending | Select-Object -First 1 | ForEach-Object EndTime
       }
    }
    catch {write-host $error;exit}
 }
 Write-Host $obj
