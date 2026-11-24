function prompt {
    $path = (Get-Location).Path

    # Replace home directory with ~
    if ($path.StartsWith($HOME, [StringComparison]::OrdinalIgnoreCase)) {
        $path = "~" + $path.Substring($HOME.Length)
    }

    Write-Host "PS " -NoNewline -ForegroundColor DarkGray
    Write-Host $path -NoNewline -ForegroundColor Cyan

    return " > "
}

# Nodejs initialization
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
