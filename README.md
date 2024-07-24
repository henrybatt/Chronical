<div align="center">

# Chronical
#### Chronical is a Windows PowerShell archiving tool designed to streamline the creation of repeated chronicals ( .zip files ).

<div align="left">

## What is it?
Chronical allows you to specify a file structure outline and repeatedly create .zip archives containing this structure.

It is designed to easily bundle the defined files into a chronical (archive) with a single run whilst preserving file structure.

You can choose specific files to be bundled or entire directories.

Chronical can be run in various configurations from a single script, to using an externally defined archive structure, or with the supporting simple use launch script.

# How to use
1. Define the archive structure by either:
	- Create a `chronical_paths` file detailing each file or directory to be bundled on individual lines.

	- Update the archive_structure variable in `chronical.ps1` with comma separated strings detailing each file and directory to be bundled.

2. Run the archive tool by either:
	- Right-click on the `chronical.ps1` script and select `Run with PowerShell`

	- Double click on the `chronical.bat` script.

3. On first run you may recieve the below security warning. If so simply select `[R] Run Once` by typing `R` into the window.
	```
	Security warning
	Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer.
	[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"):
	```

4. Your `archive.zip` file with then be created containing only the files specified in the outline.

5. Repeat step 3 to create new chronicals. Previous chronicals will be stored in the `chronical_history` directory stamped with the dates each archiver were created.


## Chronical Path Structure
The `chronical_paths` file outlines which files/directories are to be archived. The relative paths of each file is listed on a separate line.

## Batch Script
The `chronical.bat` script is an optional inclusion to make running the suite simpler. It can be safely removed if not required. `chronical.ps1` however is necessary and must remain included.

## Single Script Usage

For single file usage the `chronical.ps1` can be modified to list the paths inside the script removing the requirement for a `chronical_paths` file.

This is achieved by modifying the `$local:archive_structure` variable on line 5 from its default `""` state.

**Note:** The `$local:archive_structure` overrides the `chronical_paths` file.

### Example
``` PowerShell
From:
$local:archive_structure = ""

To:
$local:archive_structure = "first/", "second/nested/other.txt", "second/new.py"
```

**Note:** The `$local:archive_structure` variable requires comma separated strings for each path.


# Customisation

The `chronical.ps1` file contains parameters easily modifiable to change the default behaviour of the script being (found from line 8 onwards).

Simply modify the script with your chosen values.

### Parameters
``` PowerShell
# -- Parameters to modify -- #
$local:parameters = @{
    paths = @{
        source_path = "chronical_paths"		# Separate archive structure file. Overridden by 'archive_structure'
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
```

# Example

### Example

Example usages for Chronical can be found in the `example` directory for both modes, containing an example file structure and following archive.

```bash
first/
second/nested/other.txt
second/new.py
```

Simply follow the how to use steps to run Chronical in the example directories

**Note:** Not all files are inside the `chronicals_path` file structure. This is intentional to showcase the ability to skip over specfic files or directories