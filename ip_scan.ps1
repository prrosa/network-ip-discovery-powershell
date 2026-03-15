<#
.SYNOPSIS
    Descobre hosts ativos em uma rede e tenta resolver hostname usando múltiplas técnicas.

.DESCRIPTION
    Faz ping sweep na faixa de IPs definida. Para hosts online, tenta resolver hostname:
      1. DNS reverso padrão
      2. NBTSTAT (apenas Windows)
      3. Caso não consiga, marca como "Desconhecido"
    Salva resultado em CSV.

.EXAMPLE
    .\network_scan_adv.ps1 -Network "192.168.0" -Start 1 -End 254
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Network,        # Ex: "192.168.0"
    
    [int]$Start = 1,
    [int]$End = 254,
    
    [string]$OutputFile = "active_hosts.csv"
)

$results = @()

Write-Host "Iniciando scan da rede $Network.0/24..." -ForegroundColor Cyan

for ($i=$Start; $i -le $End; $i++) {
    $ip = "$Network.$i"

    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {

        $hostname = "Desconhecido"

        # 1️⃣ Tenta resolver via DNS reverso
        try {
            $dnsHost = [System.Net.Dns]::GetHostEntry($ip).HostName
            if ($dnsHost) { $hostname = $dnsHost }
        } catch {}

        # 2️⃣ Tenta resolver via NBTSTAT (somente Windows)
        if ($hostname -eq "Desconhecido") {
            try {
                $nbt = nbtstat -A $ip 2>$null | Select-String "<00>" | ForEach-Object { ($_ -split "\s+")[0] }
                if ($nbt) { $hostname = $nbt[0] }
            } catch {}
        }

        # Cria objeto para resultados
        $obj = [PSCustomObject]@{
            IP       = $ip
            Hostname = $hostname
            Status   = "ONLINE"
        }

        Write-Host "[ONLINE] $ip ($hostname)" -ForegroundColor Green
        $results += $obj
    }
}

# Salva resultados em CSV
if ($results.Count -gt 0) {
    $results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
    Write-Host "`nScan finalizado. Resultados salvos em $OutputFile" -ForegroundColor Yellow
} else {
    Write-Host "`nNenhum host ativo encontrado." -ForegroundColor Red
}
