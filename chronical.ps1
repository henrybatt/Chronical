# -- Parameters to modify -- #

# Comma separated list of files/dir to archive. Overridden by `.chronical-paths` file
$local:paths = ""

# Path of archive to create
$local:destination_path = "archive.zip" 

# Backup existing zip to this directory
$local:backup_path = "chronical_history" 

# Dir temporarily created to keep zip structure
$local:temp_path = ".chronical_temp" 

# Whether or not the shell stays open after execution
$local:leave_open = $true

# ----------------------------------------------------------------------

# Load in '.chronical-paths' file if exists
if (Test-Path ".chronical-paths") {
    $local:paths= $(Get-Content ".chronical-paths")
}

# If paths file and defined paths both empty, exit with warning
if ($local:paths -eq "") {
    Write-Host "Error: Missing path structure file`n`nPress any key to exit..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 2
}

Unblock-File ".\chronical.ps1" # Unblocks self to remove warning on second execution

# Handle existing archives
if (Test-Path $destination_path) {
    mkdir -f $local:backup_path
    mv $destination_path "$backup_path\$(Get-Date -Format "yyyy-MM-dd-HH-mm-ss").zip"
}

# Create temporary file structure
$local:temp_paths = Split-Path -Path $local:paths -Parent
mkdir -f $local:temp_path
cd $local:temp_path
mkdir -f $local:temp_paths
cd ..

# Copy into temp items
$local:paths | ForEach-Object {
    Copy-Item -Recurse -Container $_ $local:temp_path/$_   
}

# Archive the files & cleanup
Compress-Archive -DestinationPath $local:destination_path -Path $local:temp_path/* -CompressionLevel Optimal -Update

rm -r $local:temp_path

# Comment back in to 
if ($local:leave_open) {
    Write-Host "Press any key to exit..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
