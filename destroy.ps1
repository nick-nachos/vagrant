param (
    [Parameter(Mandatory=$true)]
    [string]$VM
)

function Update-SshConfig {
    param (
        [string]$VMName
    )
    $sshDir = "$env:USERPROFILE\.ssh"
    $vagrantSshDir = Join-Path $sshDir 'vagrant'
    $vagrantSshFile = Join-Path $vagrantSshDir $VMName

    # Remove the Vagrant SSH file if it exists
    if (Test-Path $vagrantSshFile) {
        Remove-Item -Path $vagrantSshFile -Force
    }
}

# Validate input
if (-not (Test-Path $VM) -or -not (Test-Path (Join-Path $VM 'Vagrantfile'))) {
    Write-Host "$VM is not a valid Vagrant VM directory"
    exit 1
}

# Store current directory
$currentDir = Get-Location

# Navigate to VM directory and destroy the Vagrant VM
Set-Location -Path $VM
vagrant destroy -f
if ($LASTEXITCODE -ne 0) {
    Set-Location -Path $currentDir
    exit 1
}

# Update SSH configuration
Update-SshConfig -VMName $VM

# Return to the original directory
Set-Location -Path $currentDir

# Remove the bootstrap directory
$bootstrapDir = Join-Path $VM 'bootstrap'
if (Test-Path $bootstrapDir) {
    Remove-Item -Path $bootstrapDir -Recurse -Force
}

exit 0