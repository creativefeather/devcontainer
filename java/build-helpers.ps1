function Prompt-YesNo {
    param(
        [Parameter(Mandatory = $false, Position = 0)]
        [Alias("Msg")]
        [string]$message = "(yes/no)",
        [Parameter(ValueFromPipeline = $true)]
        [string]$Input
    )
    # Pattern for input response
    $yes_pattern = "^(y|ye|yes)$"

    # If input is provided, use it. Otherwise, prompt the user for input
    if ($Input -ne $null) {
        $response = $Input
    }
    else {
        $response = Read-Host -Prompt $message
    }
    
    # Check if the response matches the pattern
    if ($response -imatch $yes_pattern) {
        return $true
    }
    else {
        return $false
    }
}

function New-Manifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$manifest_name,
        [Parameter(Mandatory = $true)]
        [string[]]$list
    )
    docker manifest create $manifest_name ($list -join " ")
}

function prependHostname {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$host_name,
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$string
    )
    return $host_name + "/" + $string
}

function expandList {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string[]]$images,
        [Parameter(Mandatory = $true)]
        [Alias("WithHostname")]
        [string]$hostname
    )

    if ($hostname -ne $null) {
        for ($i = 0; $i -lt $images.Length; $i++) {
            # Check if the string starts with the prefix
            if ($images[$i] -notlike "$hostname*" -and $images[$i] -notcontains "/") {
                # Prepend the prefix to the string
                $images[$i] = prependHostname $hostname $images[$i]
            }
        }
    }

    return $images -join " "
}

function New-ManifestList {
    param(
        [Parameter(Mandatory = $false)]
        [string]$manifest_name,
        [Parameter(Mandatory = $false)]
        [string[]]$image_list,
        [Parameter(Mandatory = $false)]
        [string]$registry_hostname
    )

    if ($manifest_name -eq $null) {
        Write-Host "No manifest name provided. Manifest creation skipped!"
        return
    }

    if ( $null -eq $imageList -or $imageList.Length -eq 0) {
        Write-Host "No images specified for a manifest. Manifest creation skipped!"
        return
    }

    # If registry hostname given, prepend hostname to manifest name and each image name
    if ($registry_hostname -ne $null) {
        $manifest_name = prependHostname $registry_hostname $manifest_name
        expandList $imageList -WithHostname $registry_hostname
    }

    Write-Host "Creating manifest..."
    New-Manifest -manifest_name $manifest_name -list $imageList
    return $manifest_name
}