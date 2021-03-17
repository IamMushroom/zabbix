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