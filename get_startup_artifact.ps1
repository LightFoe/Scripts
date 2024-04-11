#registry keys for Run keys
$runKeys = @(
    "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
)

#extra startup locationss
$otherLocations = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
    "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
)

#Listing items
function ListStartupItems($path) {
    $items = Get-ChildItem -Path $path -File
    if ($items) {
        foreach ($item in $items) {
            Write-Output "Location: $path, Name: $($item.Name)" | Out-File -FilePath "$env:TEMP\script_result_startup.txt" -Append
        }
    }

}
#Listing items under Run keys function
function ListRunKeys {
    foreach ($keyPath in $runKeys) {
        $runKeyValues = Get-ItemProperty -Path $keyPath
        if ($runKeyValues) {
            foreach ($valueName in $runKeyValues.PSObject.Properties.Name) {
                $valueData = (Get-ItemProperty -Path $keyPath).$valueName
                Write-Output "Location: $keyPath, Name: $valueName, Data: $($valueData -join ", ")" | Out-File -FilePath "$env:TEMP\script_result_startup.txt" -Append
            }
        }
    }
}

function ListOtherLocation {
    ListRunKeys
    foreach ($location in $otherLocations) {
        ListStartupItems $location
    }
}

#Listing items under Run keys


ListOtherLocation
