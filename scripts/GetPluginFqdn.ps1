param(
    [Parameter(Mandatory=$true)]
    [string]$DllPath
)

# Validate that the DLL file exists
if (-not (Test-Path $DllPath)) {
    Write-Error "DLL file not found: $DllPath"
    exit 1
}

try {
    # Load the assembly from the DLL path
    $assembly = [System.Reflection.Assembly]::LoadFrom($DllPath)
    
    # Return the assembly's FullName
    Write-Output $assembly.FullName
}
catch {
    Write-Error "Error loading assembly: $($_.Exception.Message)"
    exit 1
}