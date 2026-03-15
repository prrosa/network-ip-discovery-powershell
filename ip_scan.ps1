# Network IP Scanner - PowerShell
$network = "192.168.0"
$activeHosts = @()

Write-Host "Iniciando scan da rede $network.0/24..." -ForegroundColor Cyan

1..254 | ForEach-Object {
    $ip = "$network.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {
        Write-Host "[ONLINE] $ip" -ForegroundColor Green
        $activeHosts += $ip
    }
}

Write-Host "`nScan finalizado." -ForegroundColor Cyan
Write-Host "Hosts ativos encontrados:" -ForegroundColor Yellow
$activeHosts
