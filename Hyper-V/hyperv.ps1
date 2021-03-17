param($1,$2)
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Автообнарежение виртуалок
# Ключ: discovery
if ($1 -eq "discovery") {
   try {
      $items = get-vm | ForEach-Object vmid
      $tempstr = "{"
      $tempstr = $tempstr + "`"data`":["
      $n = 0
      foreach ($item in $items) {
         $n = $n + 1
         $line = "{`"{#VMID}`":`"" + ($item) + "`""
         If ($n -le $items.count) {$line = $line + ","}
         $line = $line + "`"{#VMNAME}`":`"" + (get-vm | Where-Object vmid -eq $item | ForEach-Object VMName) + "`"}"
         If ($n -lt $items.count) {$line = $line + ","}
         $tempstr = $tempstr + $line
      }
      $tempstr = $tempstr + "]"
      $tempstr = $tempstr + "}"
      $obj = $tempstr
   }
   catch {write-host $error;exit}
}

# Получение информации о виртуалках
# Ключи: 
else {
   try {
      # Ключ state – получение статуса виртуалки
      if ($2 -eq "state") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object State
      }
      # Ключ memassigned – получение памяти, выделенной виртуалке
      elseif ($2 -eq "memassigned") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object MemoryAssigned
      }
      # Ключ memdemand – получение памяти, необходимой виртуалке
      elseif ($2 -eq "memdemand") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object MemoryDemand
      }
      # Ключ memstatus – получение статуса памяти виртуалки
      elseif ($2 -eq "memstatus") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object MemoryStatus
      }
      # Ключ cpuusage – получение процессора виртуалки
      elseif ($2 -eq "cpuusage") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object CPUUsage
      }
      # Ключ dynamic – получение статуса виртуальной памяти виртуалки
      elseif ($2 -eq "dynamic") {
         $obj = get-vm | Where-Object vmid -eq $1 | ForEach-Object DynamicMemoryEnabled
      }
   }
   catch {write-host $error;exit}
}
Write-Host $obj