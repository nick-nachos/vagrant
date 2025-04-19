param (
    [Parameter(Mandatory=$true)]
    [string]$VM
)

function Export-Var {
    param (
        [string]$Name,
        [string]$Value,
        [string]$ExportFile
    )
    # Append export statement in bash-compatible format to the file
    Add-Content -Path $ExportFile -Value "export $Name='$Value'"
}

function Export-Vars {
    param (
        [string]$ExportFile
    )
    # Get Git user name and email
    $gitUserName = git config --global --get user.name
    $gitUserEmail = git config --global --get user.email

    # Validate Git configuration
    if (-not $gitUserName -or -not $gitUserEmail) {
        Write-Host "git [user.name] and [user.email] must be set up prior to this installation; run:"
        Write-Host "git config --global user.name 'Your Name'"
        Write-Host "git config --global user.email 'youremail@yourdomain.com'"
        return $false
    }

    # Remove existing export file if it exists
    if (Test-Path $ExportFile) {
        Remove-Item -Path $ExportFile -Force
    }

    # Export variables
    Export-Var -Name 'GIT_USER_NAME' -Value $gitUserName -ExportFile $ExportFile
    Export-Var -Name 'GIT_USER_EMAIL' -Value $gitUserEmail -ExportFile $ExportFile
    return $true
}

function Update-SshConfig {
    param (
        [string]$VMName
    )
    $sshDir = "$env:USERPROFILE\.ssh"
    $sshConfigFile = Join-Path $sshDir 'config'
    $vagrantSshDir = Join-Path $sshDir 'vagrant'
    $vagrantSshFile = Join-Path $vagrantSshDir $VMName

    # Check if .ssh directory exists
    if (-not (Test-Path $sshDir)) {
        Write-Host "~/.ssh directory has not been initialized"
        return $false
    }

    # Create vagrant SSH directory if it doesn't exist
    if (-not (Test-Path $vagrantSshDir)) {
        New-Item -ItemType Directory -Path $vagrantSshDir -Force | Out-Null
    }

    # Create SSH config file if it doesn't exist
    if (-not (Test-Path $sshConfigFile)) {
        New-Item -ItemType File -Path $sshConfigFile -Force | Out-Null
    }

    # Check if vagrant SSH dir is included in config
    if (-not (Test-Path $sshConfigFile) -or -not (Get-Content -Path $sshConfigFile -ErrorAction SilentlyContinue | Select-String -Pattern "Include $vagrantSshDir\*" -SimpleMatch)) {
        Add-Content -Path $sshConfigFile -Value "Include $vagrantSshDir\*"
    }

    # Generate SSH config for Vagrant
    $sshConfig = vagrant ssh-config | Select-Object -Skip 1
    Set-Content -Path $vagrantSshFile -Value "Host vagrant.$VMName"
    Add-Content -Path $vagrantSshFile -Value $sshConfig

    return $true
}

function ConvertTo-UnixLineEndings {
    param (
        [string]$Directory
    )
    # Get all files in the directory recursively
    $files = Get-ChildItem -Path $Directory -Recurse -File
    foreach ($file in $files) {
        try {
            # Read the file content
            $content = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
            if ($null -eq $content) {
                # Skip empty files
                continue
            }
            # Replace CRLF with LF
            $unixContent = $content -replace "`r`n", "`n"
            # Write back the sanitized content
            Set-Content -Path $file.FullName -Value $unixContent -NoNewline -ErrorAction Stop
            Write-Host "Sanitized line endings for: $($file.FullName)"
        }
        catch {
            Write-Warning "Failed to sanitize $($file.FullName): $_"
        }
    }
}

# Validate input
if (-not $VM) {
    Write-Host "Usage: .\install.ps1 <vm_dir>"
    exit 1
}

# Check if VM directory exists and contains Vagrantfile
if (-not (Test-Path $VM) -or -not (Test-Path (Join-Path $VM 'Vagrantfile'))) {
    Write-Host "$VM is not a valid Vagrant VM directory"
    exit 1
}

# Store current directory
$currentDir = Get-Location

# Set up export file path
$exportFile = Join-Path $VM 'bootstrap\exports.sh'

# Remove existing bootstrap directory and copy new one
$bootstrapDir = Join-Path $VM 'bootstrap'
if (Test-Path $bootstrapDir) {
    Remove-Item -Path $bootstrapDir -Recurse -Force
}
Copy-Item -Path '.\bootstrap' -Destination $VM -Recurse -Force
# Sanitize files in bootstrap directory to remove Windows line endings
ConvertTo-UnixLineEndings -Directory $bootstrapDir

# Export Git variables
$exportResult = Export-Vars -ExportFile $exportFile
if (-not $exportResult) {
    exit 1
}

# Navigate to VM directory and start Vagrant
Set-Location -Path $VM
vagrant up
if ($LASTEXITCODE -ne 0) {
    Set-Location -Path $currentDir
    exit 1
}

# Update SSH configuration
$sshResult = Update-SshConfig -VMName $VM
$installStatus = if ($sshResult) { 0 } else { 1 }

# Return to original directory and clean up
Set-Location -Path $currentDir
if (Test-Path $exportFile) {
    Remove-Item -Path $exportFile -Force
}

# Exit with the install status
exit $installStatus