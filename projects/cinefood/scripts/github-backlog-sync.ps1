# Script Oficial de Criação de Issues + Sincronização Automática com Kanban Project #1 (CineFood)
# Localização: ai-memory/projects/cinefood/scripts/github-backlog-sync.ps1
# IMPORTANTE (Windows PowerShell): Sempre executar lendo em UTF-8:
# [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; [System.IO.File]::ReadAllText("ai-memory/projects/cinefood/scripts/github-backlog-sync.ps1", [System.Text.Encoding]::UTF8) | Invoke-Expression

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$script:GitHubToken = $env:GITHUB_PERSONAL_ACCESS_TOKEN
if (-not $script:GitHubToken) {
  $script:GitHubToken = [System.Environment]::GetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", "User")
}
if (-not $script:GitHubToken) {
  $script:GitHubToken = $env:GITHUB_TOKEN
}

$script:Repo = "Cavaleiros-da-Tela-Azul/cinefood"
$script:Headers = @{
  "Authorization"        = "Bearer $script:GitHubToken"
  "Accept"               = "application/vnd.github+json"
  "User-Agent"           = "CineFood-SDD-Kanban-Sync"
  "X-GitHub-Api-Version" = "2022-11-28"
}

# IDs Oficiais do GitHub Project V2: https://github.com/orgs/Cavaleiros-da-Tela-Azul/projects/1/views/1
$script:ProjectId        = "PVT_kwDOFKkS8M4BqZhD"
$script:StatusFieldId    = "PVTSSF_lADOFKkS8M4BqZhDzhow0xQ"
$script:IterationFieldId = "PVTIF_lADOFKkS8M4BqZhDzhow02A"
$script:Iteration1Id     = "381c7c80" # Iteration 1 (2026-11-05 a 2026-11-18)

$script:StatusOptions = @{
  "Backlog"     = "f75ad846"
  "Ready"       = "e18bf179"
  "In progress" = "47fc9ee4"
  "In review"   = "aba860b9"
  "Done"        = "98236657"
}

# Mapeamento dos Milestones Oficiais já criados no repositório Cavaleiros-da-Tela-Azul/cinefood:
# 1 = MAR-01: Fundamentos (Conta, Catálogo e LGPD) [Issues #1 a #7 já criadas e no Kanban]
# 2 = MAR-02: Ingressos (Reserva 10min, Pagamento Sandbox e Meia-Entrada)
# 3 = MAR-03: Acesso e Histórico (QR Code, Portaria e Avaliação)
# 4 = MAR-04: Cantina e Gestão (Cardápio, Estoque, KDS/Runner, Estorno e LGPD)
# 5 = MAR-05: Verificação Integrada e Qualidade (RNFs e Candidata v1.0.0-rc.1)
# 6 = MAR-06: Transição, Implantação e Encerramento (Piloto v1.0.0)

function Invoke-GitHubGraphQL([string]$Query) {
  $payload = @{ query = $Query } | ConvertTo-Json -Compress
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
  return Invoke-RestMethod -Method Post -Uri "https://api.github.com/graphql" -Headers $script:Headers -Body $bytes -ContentType "application/json; charset=utf-8"
}

function Add-IssueToKanbanProject(
  [Parameter(Mandatory=$true)][string]$IssueNodeId,
  [string]$KanbanStatus = "Backlog",
  [string]$IterationId = $script:Iteration1Id
) {
  # 1. Adiciona a Issue ao Project #1
  $addRes = Invoke-GitHubGraphQL "mutation { addProjectV2ItemById(input: { projectId: `"$script:ProjectId`", contentId: `"$IssueNodeId`" }) { item { id } } }"
  $itemId = $addRes.data.addProjectV2ItemById.item.id

  # 2. Define a coluna do Kanban (Status)
  $statusOptionId = $script:StatusOptions[$KanbanStatus]
  if (-not $statusOptionId) { $statusOptionId = $script:StatusOptions["Backlog"] }
  Invoke-GitHubGraphQL "mutation { updateProjectV2ItemFieldValue(input: { projectId: `"$script:ProjectId`", itemId: `"$itemId`", fieldId: `"$script:StatusFieldId`", value: { singleSelectOptionId: `"$statusOptionId`" } }) { projectV2Item { id } } }" | Out-Null

  # 3. Vincula à Iteration 1 para aparecer imediatamente na View 1 ("Current iteration")
  Invoke-GitHubGraphQL "mutation { updateProjectV2ItemFieldValue(input: { projectId: `"$script:ProjectId`", itemId: `"$itemId`", fieldId: `"$script:IterationFieldId`", value: { iterationId: `"$IterationId`" } }) { projectV2Item { id } } }" | Out-Null

  return $itemId
}

function New-CineFoodIssue(
  [Parameter(Mandatory=$true)][string]$Title,
  [Parameter(Mandatory=$true)][int]$MilestoneNumber,
  [Parameter(Mandatory=$true)][string[]]$Labels,
  [Parameter(Mandatory=$true)][string]$Body,
  [string]$KanbanStatus = "Backlog"
) {
  $issuePayload = @{
    title     = $Title
    milestone = $MilestoneNumber
    labels    = $Labels
    body      = $Body
  }
  $json = $issuePayload | ConvertTo-Json -Depth 10 -Compress
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
  $created = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$script:Repo/issues" -Headers $script:Headers -Body $bytes -ContentType "application/json; charset=utf-8"

  $projectItemId = Add-IssueToKanbanProject -IssueNodeId $created.node_id -KanbanStatus $KanbanStatus
  Write-Output "Issue #$($created.number) criada e adicionada ao Kanban ($KanbanStatus / Iteration 1): $($created.title) [ProjectItem: $projectItemId]"
  return $created
}
