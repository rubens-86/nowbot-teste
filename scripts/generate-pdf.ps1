# Criar diretório para documentação se não existir
New-Item -ItemType Directory -Force -Path ".\nowbot-docs"
Set-Location ".\nowbot-docs"

Write-Host "Gerando PDF..." -ForegroundColor Green

# Gerar PDF usando Pandoc
pandoc manual.md `
    -o "Manual_Tecnico_NowBot_v6.0.0.pdf" `
    --from markdown+yaml_metadata_block+raw_html `
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