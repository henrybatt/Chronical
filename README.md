<div align="center">

# Chronical
#### Chronical is a Windows PowerShell archiving tool designed to streamline the creation of repeated chronicals ( .zip files ).

<div align="left">

## What is it?
Chronical allows you to specify a file structure outline and repeatedly create .zip archives containing this structure.

It is designed to easily bundle the defined files into a chronical (archive) with a single run whilst preserving file structure.

You can choose specific files to be bundled or entire directories

# How to use
1. Define a `.chronical-paths` file detailing the files to be bundled into a chronical.

2. Right-click on the `chronical.ps1` script and select `Run with PowerShell`

3. On first run you may recieve the below security warning. If so simply select `[R] Run Once` by typing `R` into the window.
	```
	Security warning
	Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your computer.
	[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"):
	```

4. Your `chronical.zip` file with then be created containing only the files specified in the outline.

5. Repeat step 3 to create new chronicals. Previous chronicals will be stored in the `chronical_history` directory stamped with the date they were replaced


# Example

An example usage can be found in the `example` directory containing an example file structure and `.chronicals-path` file.

Simply follow the how to use steps to run the `chronicals.ps1` file in this directory

**Note:** Not all files are inside the `.chronicals-path` file structure. This is intentional to showcase the ability to skip over specfic files or directories