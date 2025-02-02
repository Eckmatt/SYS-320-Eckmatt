Class DirToBackup
{
    [String]$path
    DirToBackup([String]$path) {
      $this.path = $path
    }
}
$defaultListOfExcluded = "C:\backup\listOfExcluded.txt"
$pathFromPrefix = "C:\"
$pathToPrefix = "F:\Backup\"
Write-Output "Plug external disk drive. It should be visible as F drive"
pause
$dirsToBackup = @(
    New-Object DirToBackup "Users\meckh"
    New-Object DirToBackup ""
    New-Object DirToBackup "Dropbox"
    New-Object DirToBackup "Google"
)
$dirsToBackup | ForEach-Object {
    mkdir -Path $($pathToPrefix + $_.path) -Force
    xcopy $($pathFromPrefix + $_.path) $($pathToPrefix + $_.path) /D /S /Y /H /EXCLUDE:$defaultListOfExcluded
}
pause