param($1,$2)

# Автообнарежение дисков
# Ключ: discovery
if ($1 -eq "discovery") {
try {
$items = c:\"Program Files"\smartmontools\bin\smartctl --scan-open | Where-Object {$_ -match "/dev/sd"}

write-host -NoNewline "{"
write-host -NoNewline "`"data`":["

$n = 0
foreach ($obj in $items) {
	if ($null -ne (c:\"Program Files"\smartmontools\bin\smartctl -i $obj.substring(0,8) | Where-Object {$_ -match "SMART support is: Enabled"})) {
	$n = $n + 1
	If ($n -gt 1) {write-host -NoNewline ","}    
	$line =  "{`"{#DISKID}`":`"" + ($obj.substring(5,3)) + "`"}"
    write-host -NoNewline $line
	}
 }
write-host -NoNewline "]"
write-host -NoNewline "}"

}
catch {write-host $error;exit}
}

# Получение информации от дисков
# Ключи: 
else {
try {
if ($2 -eq "status") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -H /dev/$1 | Where-Object {$_ -match "result:"}
$obj = $obj.substring(50)
}
elseif ($2 -eq "model") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -i /dev/$1 | Where-Object {$_ -match "Device Model:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "family") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -i /dev/$1 | Where-Object {$_ -match "Model Family:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "fw") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -i /dev/$1 | Where-Object {$_ -match "Firmware Version:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "serial") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -i /dev/$1 | Where-Object {$_ -match "Serial Number:"}
$obj = $obj.substring(18)
}
elseif ($2 -eq "capacity") {
$obj = c:\"Program Files"\smartmontools\bin\smartctl -i /dev/$1 | Where-Object {$_ -match "User Capacity:"}
    if ($obj -match "User Capacity:") {
    $obj = $obj.Substring($obj.IndexOf("[")+1,$obj.IndexOf("]")-$obj.IndexOf("[")-1)
    }
    else {
    $obj = "N/A"
    }}


# Получение показателей SMART
# Значения без скобок и их содержимого
else {

$obj = c:\"Program Files"\smartmontools\bin\smartctl -A /dev/$1 | Where-Object {$_ -match "^ *$2"}
    try {$obj = $obj.Substring(87,$obj.IndexOf("(")-87)}
    catch {$obj = $obj.Substring(87)}
}}
catch {$obj = ""}

Write-Output $obj
}