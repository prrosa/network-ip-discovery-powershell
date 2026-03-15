# Network IP Discovery - PowerShell

## Descrição
Script avançado em PowerShell para **descoberta de hosts ativos em redes corporativas**. Realiza um **ping sweep** na faixa de IP definida e tenta resolver o **hostname** de cada host usando múltiplas técnicas (DNS reverso e NBTSTAT para máquinas Windows). Ideal para **inventário de ativos, auditoria de rede, troubleshooting e análise de conectividade**.

## Funcionalidades
- Identifica IPs ativos na rede.
- Resolve hostname sempre que possível.
- Exporta resultados para CSV, pronto para auditoria ou relatórios.
- Flexível: permite definir faixa de IP (`Start` e `End`) e arquivo de saída.
- Feedback visual no console com cores, destacando hosts online.

## Exemplo de uso
```powershell
# Scan padrão da rede 192.168.0.1-254
.\network_scan_adv.ps1 -Network "192.168.0"

# Scan customizado e salvar em arquivo específico
.\network_scan_adv.ps1 -Network "192.168.1" -Start 50 -End 150 -OutputFile "hosts_rede.csv"
