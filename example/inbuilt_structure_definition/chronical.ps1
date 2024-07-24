## -!- Chronical Archiver -!- ##

# -- Archive Structure -- #
# Which files and directories should be included in the archive. Formatted as comma separated strings. Overrides the 'source_path'.
$local:archive_structure = "first/", "second/nested/other.txt", "second/new.py"

# -- Parameters to modify -- #
$local:parameters = @{
    paths = @{
        source_path = "chronical_paths"	# Optional file with archive structure. Only used if 'archive_structure' is empty. Each archive item should be on a new line.
        destination_path = "archive.zip"	# Path of archive to create
        backup_path = "chronical_history\"	# Backup existing zip to this directory
        temp_path = "chronical_temp"		# Temporarily zip directroy preserve zip structure
    }
    make_backups    = $true			# Whether or not to keep backups of old archives. Iff false they are just overridden.
    leave_open      = $true			# Whether or not the shell stays open after execution
    skip_non_exist  = $true			# Skip over files that don't exist. Iff false the program halts
    silent          = $false		# Hide console output (Overridden if verbose mode is enabled)
    verbose         = $false		# Echo out verbose messages (Overrides silent mode)
    compression_level = "Optimal"	# The compression level of archive (Optimal, Fastest, NoCompression)
}

# ----------------------------------------------------------------------

# Unblock script to remove warning on usage
if ($parameters.verbose) { echo "Unblocking script" };
Unblock-File "$PSScriptRoot\$($MyInvocation.MyCommand.Name)"

# Convert paths from local to absolute.
if ($parameters.verbose) { echo "Expanding paths from local to absolute" };
foreach ($local:path in @($parameters.paths.keys)) {
    $parameters.paths[$path] = "$PSScriptRoot\$($parameters.paths[$path])"
}

# If structure not defined by 'archive_structure' attempt to load in the 'source_path' file.
if ($parameters.verbose) { echo "Loading archive structure" };
if ($archive_structure -eq "") {
    if ($parameters.verbose) { echo "Attempt to load separate structure file" };
    if (Test-Path $parameters.paths.source_path) {
        if ($parameters.verbose) { echo "Loaded in file" };
        $archive_structure = $(Get-Content $parameters.paths.source_path)
    } else {
        echo "Error: Missing archive structure."
        rm -r $parameters.paths.temp_path # Cleanup previous files
        if (parameters.leave_open) {Write-Host "`n`nPress any key to exit..."; $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
        exit 2
    }
}

# Handle backup creation if required
if ($parameters.verbose) { echo "Checking if backup needs to be made" };
if ($parameters.make_backups -And (Test-Path $parameters.paths.destination_path)) {
    if ($parameters.verbose) { echo "Making a backup of previous archive" };
    mkdir -f $parameters.paths.backup_path | Out-Null
    mv $parameters.paths.destination_path "$($parameters.paths.backup_path)\$($(Get-Item $($parameters.paths.destination_path)).creationTime.ToString(`"yyyy-MM-dd#HH-mm-ss`")).zip"
}

# Create a temporary directory for structure preservation
if ($parameters.verbose) { echo "Creating temporary directory for archive" };
mkdir -f $parameters.paths.temp_path | Out-Null
foreach ($file in $archive_structure) {
    if (Test-Path "$PSScriptRoot\$file") {
        if ($parameters.verbose) { echo "Archiving $file" };
        mkdir -f "$($parameters.paths.temp_path)\$(Split-Path -Path $file -Parent)" | Out-Null
        Copy-Item -Recurse -Container "$PSSCriptRoot\$file" "$($parameters.paths.temp_path)\$file"
    } elseif (! $parameters.skip_non_exist) {
        echo "ERROR: Missing file from structure: $file"
        if (parameters.leave_open) {Write-Host "`n`nPress any key to exit..."; $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
        exit 3
    } elseif (! $parameters.silent -Or $parameters.verbose) {
        echo "Skipped Missing File: $file"
    }
}

# Archive the files & cleanup 
if ($parameters.verbose) { echo "Archiving $file" };
Compress-Archive -Update -DestinationPath $parameters.paths.destination_path -Path "$($parameters.paths.temp_path)/*" -CompressionLevel $parameters.compression_level
rm -r $parameters.paths.temp_path

# Keep prompt open after running till key press
if ($parameters.leave_open) {
    if (! $parameters.silent -Or $parameters.verbose) { echo "Done" };
    Write-Host "Press any key to exit..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
