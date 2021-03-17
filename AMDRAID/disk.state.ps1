param($1,$2)

$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}

# Формируем файл с таблицей данных и делаем отбор
cd "C:\Program Files (x86)\RAIDXpert2"
.\rcadm -M -q -a * -d * > "c:\usr\amd.txt"
$result = Select-String -Path "c:\usr\amd.txt" -SimpleMatch "NVMe"
$len = $result.length

# Формируем массивы с данными дисков и заполняем их из таблицы данных
$num = @()
$sta = @()
$nam = @()
$ser = @()
$cap = @()
for($i=$len-1;$i -ge 0 ;$i--){
	$tmp =  $result[$i].ToString()
	$n=$tmp.Substring(18,1);
	$num += $n
	$sta += $tmp.Substring(23,6)
	$nam += $tmp.Substring(106,15)
	$ser += $tmp.Substring(142,15)
	$cap += $tmp.Substring(66,7)
}

# Формируем строку discovery для Заббикса
if ($1 -eq "discovery") {
	try{

		Write-Host -NoNewLine "{"
		Write-Host -NoNewLine "`"data`":["

		$n = 0
		foreach ($obj in $num) {
			$n = $n + 1
			if ($n -gt 1) {Write-Host -NoNewLine ","}
			$line = "{`"{#DISKID}`":`"" + $obj + "`"}"
			Write-Host -NoNewLine $line
			}
		Write-Host -NoNewLine "]"
		Write-Host -NoNewLine "}"
		}
	Catch {Write-Host $error; exit}
}

# Получаем информацию о дисках
# Ключи
else {
	try {
		if ($2 -eq "state") {
			$obj = $sta[$1]
		}
		elseif ($2 -eq "name") {
			$obj = $nam[$1]
		}
		elseif ($2 -eq "serial") {
			$obj = $ser[$1]
		}
		elseif ($2 -eq "size") {
			$obj = $cap[$1]
		}
		else {
			$obj = "Disk "+ $num[$1]  + " | " + $nam[$1] + " | Size: " + $cap[$1] + " | State: " + $sta[$1] + " | Serial: " + $ser[$1]
		}
	}
	catch {$obj = ""}
	Write-Output $obj
}


<#	

Write-Host
Write-Host("-------------------------------------------------------")
for($i=0;$i -lt $len;$i++){
Write-Host("Disk "+ $num[$i]  + " | " + $nam[$i] + " | State: " + $sta[$i] + " | Serial: " + $ser[$i])
}



Write-Host("-------------------------------------------------------")
$Num1 =  $result[0].ToString()
$Num1 =  

$Num2 =  $result[1].ToString()
$Num2 =  $Num2.Substring(18,1)
Write-Host("-------------------------------------------------------")

$Sta1 =  $result[0].ToString()
$Sta1 =  $Sta1.Substring(23,6)

$Sta2 =  $result[1].ToString()
$Sta2 =  $Sta2.Substring(23,6)

$Nam1 =  $result[0].ToString()
$Nam1 =  $Nam1.Substring(106,15)

$Nam2 =  $result[1].ToString()
$Nam2 =  $Nam2.Substring(106,15)



Write-Host("Disk $Num1 | $Nam1 | State: $Sta1")
Write-Host("Disk $Num2 | $Nam2 | State: $Sta2")


"$d1 " + " $d2" | Out-File c:\usr\amd1.txt

Add-content -Path c:\usr\amd.txt -value $d1
Add-content -Path c:\usr\amd.txt -value $d2





stop-process -Id $PID
#>