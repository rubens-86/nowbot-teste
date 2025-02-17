# Criar diretório para documentação
New-Item -ItemType Directory -Force -Path ".\nowbot-docs"
Set-Location ".\nowbot-docs"

Write-Host "Iniciando criação do Manual Técnico NowBot..." -ForegroundColor Blue

# Instalar Chocolatey se não estiver instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Chocolatey..." -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Instalar dependências via Chocolatey
Write-Host "Instalando dependências..." -ForegroundColor Green
choco install -y pandoc
choco install -y miktex

# Configurar template
Write-Host "Configurando template..." -ForegroundColor Green
$templateUrl = "https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex"
$templatePath = "$env:USERPROFILE\.pandoc\templates"

New-Item -ItemType Directory -Force -Path $templatePath
Invoke-WebRequest -Uri $templateUrl -OutFile "$templatePath\eisvogel.latex"

# Gerar arquivo Markdown
Write-Host "Gerando arquivo Markdown..." -ForegroundColor Green
$markdownContent = @'
[Conteúdo do manual.md aqui]
'@

$markdownContent | Out-File -FilePath "manual.md" -Encoding UTF8

# Gerar PDF
Write-Host "Gerando PDF..." -ForegroundColor Green
pandoc manual.md `
    -o "Manual_Tecnico_NowBot_v6.0.0.pdf" `
    --from markdown+yaml_metadata_block+raw_html `
    --template eisvogel `
    --table-of-contents `
    --toc-depth 3 `
    --number-sections `
    --top-level-division=chapter `
    --highlight-style tango `
    --pdf-engine=xelatex `
    --variable geometry:margin=1in `
    --variable links-as-notes=true `
    --variable papersize=a4 `
    --variable fontsize=11pt `
    --variable monofont="DejaVu Sans Mono" `
    --variable monofontoptions=Scale=0.9 `
    --variable urlcolor=blue `
    --variable linkcolor=blue `
    --variable babel-lang=brazilian

Write-Host "Manual gerado com sucesso!" -ForegroundColor Green
Write-Host "O arquivo PDF está disponível em: $(Get-Location)\Manual_Tecnico_NowBot_v6.0.0.pdf" 