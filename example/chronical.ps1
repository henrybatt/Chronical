# -- Parameters to modify -- #

# Comma separated list of files/dir to archive. Overridden by `.chronical-paths` file
$local:paths = "first", "second/nested/other.txt", "second/new.py"

# Path of archive to create
$local:destination_path = "archive.zip" 

# Backup existing zip to this directory
$local:backup_path = "chronical_history" 

# Dir temporarily created to keep zip structure
$local:temp_path = ".chronical_temp" 

# Whether or not the shell stays open after execution
$local:leave_open = $true

# Change the compression level of archive (Optimal, Fastest, NoCompression)
$local:compression_level = "Optimal"

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

# Unblocks self to remove warning on second execution
Unblock-File ".\chronical.ps1"

# Handle existing archives
if (Test-Path $destination_path) {
    mkdir -f $local:backup_path
    mv $destination_path "$backup_path\$(Get-Date -Format "yyyy-MM-dd-HH-mm-ss").zip"
}

# Create temporary file
mkdir -f $local:temp_path

# Copy into temp items
$local:paths | ForEach-Object {

    # Ensure file structure is preserved
    $local:parent = Split-Path -Path $_ -Parent
    if (($local:parent -ne "") -and (!(Test-Path $local:temp_path/$local:parent))) {
        mkdir -f $local:temp_path/$local:parent
    }

    Copy-Item -Recurse -Container $_ $local:temp_path/$_   
}

# Archive the files & cleanup
Compress-Archive -Update -DestinationPath $local:destination_path -Path $local:temp_path/* -CompressionLevel $local:compression_level 
rm -r $local:temp_path

# Comment back in to 
if ($local:leave_open) {
    Write-Host "Press any key to exit..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
