# 1. Visual Enhancements
try {
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }
} catch {}

# 2. PSReadLine Configuration
try {
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Import-Module PSReadLine
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin
            Set-PSReadLineOption -PredictionViewStyle ListView
            Set-PSReadLineOption -Colors @{
                Command            = "#80FFEA"
                Parameter         = "#FF9580"
                String            = "#FFFF80"
                Number            = "#9580FF"
                Member            = "#8AFF80"
                Operator          = "#FF80BF"
                Variable          = "#AA99FF"
                InlinePrediction  = "#504C67"
            }
            Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
            Set-PSReadLineKeyHandler -Key "Ctrl+Spacebar" -Function AcceptSuggestion
            Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function ViExit
        } else {
            Set-PSReadLineOption -Colors @{
                Command   = "Cyan"
                Parameter = "DarkRed"
                String    = "Yellow"
                Number    = "Magenta"
                Member    = "Green"
                Operator  = "DarkMagenta"
                Variable  = "DarkCyan"
            }
            Set-PSReadLineKeyHandler -Key Tab -Function Complete
            Set-PSReadLineKeyHandler -Chord "Ctrl+d" -Function DeleteChar
        }
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadLineOption -BellStyle None
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    }
} catch {}

# 3. Enhanced Prompt (Git Integration Removed)
function prompt {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $adminSymbol = if ($isAdmin) { "[ADMIN] " } else { "" }
    $location = if ($PSVersionTable.PSVersion.Major -ge 7) { $PWD.Path } else { $(Get-Location).Path }
    if ($location.Length -gt 30) {
        $location = "..." + $location.Substring($location.Length - 27)
    }
    
    Write-Host "$adminSymbol" -NoNewline -ForegroundColor $(if ($isAdmin) { "Red" } else { "Green" })
    Write-Host "PS " -NoNewline -ForegroundColor Cyan
    Write-Host $location -NoNewline -ForegroundColor Yellow
    Write-Host " λ " -NoNewline -ForegroundColor Magenta
    return " "
}

# 4. Custom Find Functions
function find {
    param([Parameter(Mandatory=$true, Position=0)][string]$Pattern)
    try {
        Get-ChildItem -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$Pattern*" } | ForEach-Object {
            Write-Host $_.FullName -ForegroundColor $(if ($_.PSIsContainer) { "Blue" } else { "White" })
        }
    } catch {}
}

# 5. Aliases
Set-Alias np "C:\Program Files\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue
Set-Alias npp "C:\Program Files\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue
Set-Alias notepad "C:\Program Files\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue
Set-Alias ll Get-ChildItem -ErrorAction SilentlyContinue
Set-Alias grep Select-String -ErrorAction SilentlyContinue
Set-Alias which Get-Command -ErrorAction SilentlyContinue
Set-Alias cat Get-Content -ErrorAction SilentlyContinue
Set-Alias touch New-Item -ErrorAction SilentlyContinue
Set-Alias cp Copy-Item -ErrorAction SilentlyContinue
Set-Alias mv Move-Item -ErrorAction SilentlyContinue
Set-Alias rm Remove-Item -ErrorAction SilentlyContinue
Set-Alias cls Clear-Host -ErrorAction SilentlyContinue
Set-Alias history Get-History -ErrorAction SilentlyContinue
Set-Alias df Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}} -ErrorAction SilentlyContinue
Set-Alias du Get-ChildItem -Recurse | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue

# 6. Navigation Functions
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function z {
    param($path)
    if ($path) {
        $result = (zoxide query --exclude $PWD $path) -replace '/', '//'
        lf -remote "send $env:id cd '$result'"
    }
}
function zi {
    $result = (zoxide query -i) -replace '/', '//'
    lf -remote "send $env:id cd '$result'"
}
function aj {
    param($string)
    if ($string) {
        lf -remote "send $env:id cd `"$(autojump $string)`""
    }
}

# 7. File/Directory Operations
function mkd { param([string]$Name) New-Item -ItemType Directory -Name $Name -ErrorAction SilentlyContinue }
function mkdir { param([string]$Name) New-Item -ItemType Directory -Name $Name -ErrorAction SilentlyContinue }
function rmdir { param([string]$Path) Remove-Item -Path $Path -Recurse -ErrorAction SilentlyContinue }
function nf { param([string]$Name) New-Item -ItemType File -Name $Name -ErrorAction SilentlyContinue }
function mkcd { param($dir) New-Item $dir -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $dir }
function del {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Host "Path not found: $Path" -ForegroundColor Red
        return
    }
    try {
        $item = Get-Item $Path -ErrorAction Stop
        if ($item.PSIsContainer) {
            $subItems = Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
            $fileCount = ($subItems | Where-Object { -not $_.PSIsContainer }).Count
            $folderCount = ($subItems | Where-Object { $_.PSIsContainer }).Count
            Write-Host "`nYou're about to delete:" -ForegroundColor Yellow
            if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "📁 Folder: " -NoNewline -ForegroundColor Blue } else { Write-Host "Folder: " -NoNewline -ForegroundColor Blue }
            Write-Host "$($item.Name)" -ForegroundColor White
            Write-Host "   Contains: $fileCount files and $folderCount subfolders" -ForegroundColor Gray
            if ($fileCount -gt 0 -or $folderCount -gt 0) {
                Write-Host "`nFirst few items:" -ForegroundColor Gray
                $subItems | Select-Object -First 5 | ForEach-Object {
                    if ($PSVersionTable.PSVersion.Major -ge 7) { $type = if ($_.PSIsContainer) { "📁" } else { "📄" } } else { $type = if ($_.PSIsContainer) { "DIR" } else { "FILE" } }
                    Write-Host "  $type $($_.Name)" -ForegroundColor Gray
                }
                if ($subItems.Count -gt 5) { Write-Host "  ... and $($subItems.Count - 5) more items" -ForegroundColor DarkGray }
            }
        } else {
            Write-Host "`nYou're about to delete:" -ForegroundColor Yellow
            if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "📄 File: " -NoNewline -ForegroundColor Green } else { Write-Host "File: " -NoNewline -ForegroundColor Green }
            Write-Host "$($item.Name)" -ForegroundColor White
            Write-Host "   Size: $([math]::Round($item.Length/1KB,2)) KB" -ForegroundColor Gray
        }
        Write-Host "`nAre you sure? (y/N): " -NoNewline -ForegroundColor Red
        $confirmation = Read-Host
        if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "✅ Deleted successfully!" -ForegroundColor Green } else { Write-Host "Deleted successfully!" -ForegroundColor Green }
        } else {
            if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "❌ Deletion cancelled." -ForegroundColor Yellow } else { Write-Host "Deletion cancelled." -ForegroundColor Yellow }
        }
    } catch {
        if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "❌ Error deleting: $($_.Exception.Message)" -ForegroundColor Red } else { Write-Host "Error deleting: $($_.Exception.Message)" -ForegroundColor Red }
    }
}

# 8. System Information Functions
function ports { netstat -ano }
function processes { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 }
function diskspace { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}} }
function myip { try { (Invoke-WebRequest -Uri "https://api.ipify.org").Content } catch { "Unable to get IP" } }
function localip {
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object IPAddress, InterfaceAlias
    } else {
        Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.InterfaceAlias -notlike "*Loopback*"} | Select-Object IPAddress, InterfaceAlias
    }
}

# 9. Utility Functions
function size { if ($PSVersionTable.PSVersion.Major -ge 7) { Get-ChildItem | Measure-Object -Property Length -Sum | ForEach-Object {"{0:N2} MB" -f ($_.Sum / 1MB)} } else { (Get-ChildItem | Measure-Object -Property Length -Sum).Sum / 1MB | ForEach-Object { "{0:N2} MB" -f $_ } } }
function h { param([string]$Pattern) Get-History | Where-Object {$_.CommandLine -like "*$Pattern*"} }
function kill { param([string]$Input) if ($Input -match '^\d+$') { Stop-Process -Id $Input -Force -ErrorAction SilentlyContinue } else { Stop-Process -Name $Input -Force -ErrorAction SilentlyContinue } }
function flushdns { ipconfig /flushdns }

# 10. Profile Management
function prof {
    Write-Host "Opening PowerShell profile in Notepad++..." -ForegroundColor Green
    if (Get-Command notepad++ -ErrorAction SilentlyContinue) { notepad++ $PROFILE } else { notepad $PROFILE }
}
function rl {
    Write-Host "Reloading PowerShell profile..." -ForegroundColor Green
    . $PROFILE
}
function profile {
    Write-Host "Opening profile location in Explorer..." -ForegroundColor Green
    if ($PSVersionTable.PSVersion.Major -ge 7) { explorer (Split-Path $PROFILE) } else { explorer /select,$PROFILE }
}
function Edit-Profile { code $PROFILE }
function Reload-Profile { . $PROFILE }

# 11. Security Functions
function check-svchost { Get-Process -Name svchost | Select-Object Id, Path, @{Name="Services";Expression={(Get-WmiObject -Query "SELECT * FROM Win32_Service WHERE ProcessId = $($_.Id)").Name}} }
# Install Terminal-Icons for better file/folder icons
Install-Module -Name Terminal-Icons -Scope CurrentUser -Force

# PSReadLine is usually included, but you can update it
Install-Module -Name PSReadLine -Scope CurrentUser -Force -AllowPrerelease
# 12. Help Function
function qq {
    Write-Host "Custom Commands:" -ForegroundColor Cyan
    Write-Host "ll            : List dir (like 'dir')" -NoNewline; Write-Host "          grep          : Search in files" -ForegroundColor Gray
    Write-Host "which         : Find command path" -NoNewline; Write-Host "        cat/touch     : Show/create file" -ForegroundColor Gray
    Write-Host "..            : Up 1 dir" -NoNewline; Write-Host "                ...           : Up 2 dirs" -ForegroundColor Gray
    Write-Host "....          : Up 3 dirs" -NoNewline; Write-Host "              mkd/mkdir     : Make dir" -ForegroundColor Gray
    Write-Host "del <path>    : Delete (with warning)" -NoNewline; Write-Host "        rm <path>     : Delete (no warning)" -ForegroundColor Gray
    Write-Host "cp/mv         : Copy/move files" -NoNewline; Write-Host "        rmdir <path>  : Remove directory" -ForegroundColor Gray
    Write-Host "nf <name>     : Create file" -NoNewline; Write-Host "             cls           : Clear screen" -ForegroundColor Gray
    Write-Host "ports         : Show open ports" -NoNewline; Write-Host "         processes     : Top 20 CPU processes" -ForegroundColor Gray
    Write-Host "diskspace/df  : Disk usage" -NoNewline; Write-Host "           myip/localip  : Show IP addresses" -ForegroundColor Gray
    Write-Host "du/size       : Directory size" -NoNewline; Write-Host "         h <pattern>   : Search history" -ForegroundColor Gray
    Write-Host "prof          : Edit profile" -NoNewline; Write-Host "            rl            : Reload profile" -ForegroundColor Gray
    Write-Host "profile       : Open profile folder" -NoNewline; Write-Host "     kill <name/id>: Stop process" -ForegroundColor Gray
    Write-Host "find <pattern>: Search files/folders" -NoNewline; Write-Host "     flushdns      : Flush DNS cache" -ForegroundColor Gray
    Write-Host "check-svchost : Verify svchost" -NoNewline; Write-Host "         history       : Command history" -ForegroundColor Gray
    Write-Host "z/zi/aj       : lf navigation" -NoNewline; Write-Host "         mkcd <dir>    : Make and cd to dir" -ForegroundColor Gray
    Write-Host "Edit-Profile  : Edit in VS Code" -NoNewline; Write-Host "         Reload-Profile: Reload profile" -ForegroundColor Gray
    Write-Host "np/npp/notepad: Open Notepad++" -NoNewline; Write-Host "         " -ForegroundColor Gray
}

# 13. Startup Message
Write-Host "• PowerShell $(if ($PSVersionTable.PSVersion.Major -ge 7) { '7+' } else { '5.x' }) Profile Loaded" -ForegroundColor Magenta
Write-Host "• Custom Find Functions:" -ForegroundColor Magenta
Write-Host "  - find <pattern>        : Search files & folders" -ForegroundColor Gray
Write-Host "• Quick Commands:" -ForegroundColor Magenta
Write-Host "  - .. / ... / ....       : Navigate up directories" -ForegroundColor Gray
Write-Host "  - mkd/mkdir/mkcd <name> : Create directory" -ForegroundColor Gray
Write-Host "  - myip / localip        : Show IP addresses" -ForegroundColor Gray
Write-Host "  - processes / diskspace : System information" -ForegroundColor Gray
Write-Host "  - h <pattern>           : Search command history" -ForegroundColor Gray
Write-Host "  - check-svchost         : Verify svchost processes" -ForegroundColor Gray
Write-Host "  - z/zi/aj               : lf navigation" -ForegroundColor Gray
Write-Host "  - np/npp/notepad        : Open Notepad++" -ForegroundColor Gray
Write-Host "• Type 'qq' for full command list" -ForegroundColor Cyan
if ($PSVersionTable.PSVersion.Major -ge 7) { Write-Host "• (Ctrl+Space) for suggestions" -ForegroundColor Cyan }
Write-Host "🗂️  lf navigation ready: z <path>, zi (interactive), aj <string>, lf" -ForegroundColor Cyan

# 14. System Info on Startup
function Show-SystemInfo {
    Write-Host "System Info" -ForegroundColor Yellow
    Write-Host "-----------"
    Write-Host "OS: $((Get-CimInstance Win32_OperatingSystem).Caption)"
    Write-Host "CPU: $((Get-CimInstance Win32_Processor).Name)"
    Write-Host "RAM: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB)) GB"
    Write-Host "User: $env:USERNAME"
    Write-Host "Host: $env:COMPUTERNAME"
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
    Write-Host "-----------"
}
Show-SystemInfo

# 15. Optional Fortune Cookie
if (Get-Command fortune -ErrorAction SilentlyContinue) {
    fortune | Write-Host -ForegroundColor Cyan
}

# 16. Always show commands on startup/reload
qq
