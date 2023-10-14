$isAdmin = [bool]([System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544")
if ($isAdmin) {
  & write-host "installing dependecies"
  & choco install unzip wget lazygit fd llvm mingw ripgrep -y
} 
else {
  & write-host "skipping dependecies check, please run as admin to check"
}
& scoop install mingw make -y
& refreshenv
$makeExe = "$(scoop prefix name)/bin/make.exe"
# Prompt for variables
$requested_features = Read-Host "Enter features to enable, comma separated list?(all|none|csharp|yml|rust|copilot|python|docker), default is 'all'"
if(!$requested_features){ $requested_features = 'all' }

$features = $requested_features.Split(',')
# Define paths
$nvim_config = "$env:APPDATA\..\Local\nvim"
$nvim_data = "$env:APPDATA\..\Local\nvim-data"

# Define backup paths
$backup_paths = @("$env:APPDATA\..\Local\nvim_bak", "$env:APPDATA\..\Local\nvim_data_bak")

# Delete old backups
foreach ($path in $backup_paths){
    if(Test-Path $path){
        Remove-Item -Path $path -Recurse -Force
    }
}

# Backup current Neovim files
Rename-Item -Path $nvim_config -NewName "nvim_bak"
Rename-Item -Path $nvim_data -NewName "nvim_data_bak"

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter $nvim_config

# Remove .git folder
Remove-Item -Path "$nvim_config\.git" -Recurse -Force

# Copy overrides
Copy-Item -Path ".\lua\" -Destination "$nvim_config" -Recurse -Force

# Sync LazyVim
& nvim --headless +"lua require('lazy').sync({wait = true})" +qa

function AddLineAfterMarker {
    param (
        [string]$FilePath,
        [string]$NewLine,
        [string]$Marker
    )

    $trimmedNewLine = $NewLine
    $trimmedMarker = $Marker.Trim()

    (Get-Content $FilePath) | ForEach-Object {
        $trimmedLine = $_.Trim()
        $_
        if ($trimmedLine -eq $trimmedMarker) {
            $trimmedNewLine
        }
    } | Set-Content $FilePath
}

# Enable & install requested features
foreach($feature in $features){
    switch($feature){
        'yml' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.lang.yaml" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
            & nvim --headless +"Lazy! load mason.nvim" +"MasonInstall yaml-language-server" +q
        }
        'rust' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.lang.rust" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
            & nvim --headless +"Lazy! load mason.nvim" +"MasonInstall rust-analyzer" +q
        }
        'python' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.lang.python" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
            & nvim --headless +"Lazy! load mason.nvim" +"MasonInstall pyright" +q
        }
        'docker' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.lang.docker" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
            & nvim --headless +"Lazy! load mason.nvim" +"MasonInstall docker-compose-language-service" +q
        }
        'csharp' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.lang.omnisharp" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
            & nvim --headless +"Lazy! load mason.nvim" +"MasonInstall omnisharp" +q
        }
        'copilot' {
            AddLineAfterMarker -FilePath "$nvim_config\lua\config\lazy.lua" -NewLine '{ import = "lazyvim.plugins.extras.coding.copilot" },' -Marker '{ "LazyVim/LazyVim", import = "lazyvim.plugins" },'
        }
    }
}

# Sync LazyVim again
& nvim --headless +"lua require('lazy').sync({wait = true})" +qa

# Compile treesitter
$ts_languages = "bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap", "markdown", "markdown_inline", "python", "query", "regex", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", "rust", "dockerfile"
foreach($language in $ts_languages){
    & write-host ""
    & nvim --headless +"Lazy! load nvim-treesitter" +"TSInstallSync! $language" +q
}

#compile fzf for tree-sitter as a workaroud
& cd %AppData%\..\Local\nvim-data\lazy\telescope-fzf-native.nvim
& $makeExe
