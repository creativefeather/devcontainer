# TODO: WARNING: The names of some imported commands from the module 'BuildHelpers'
# include unapproved verbs that might make them less discoverable. To find the
# commands with unapproved verbs, run the Import-Module command again with the 
# Verbose parameter. For a list of approved verbs, type Get-Verb.

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
    if ($null -ne $Input -and $Input.Length -gt 0) {
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

class BuildSpec {
    [string]$BaseImage
    [string]$Dockerfile
    [string]$Name
    [string]$Platform
    [string]$Tag
    [string]$TargetStage

    BuildSpec() { }

    static [BuildSpec]fromHashtable([hashtable]$spec) {
        $new = [BuildSpec]::new()

        if ($null -eq $spec) {
            return $new
        }

        switch ($spec.Keys) {
            "BaseImage" { $new.BaseImage = $spec["BaseImage"] }
            "Dockerfile" { $new.Dockerfile = $spec["Dockerfile"] }
            "Name" { $new.Name = $spec["Name"] }
            "Platform" { $new.Platform = $spec["Platform"] }
            "Tag" { $new.Tag = $spec["Tag"] }
            "TargetStage" { $new.TargetStage = $spec["TargetStage"] }
        }

        return $new
    }

    [void]display() {
        Write-Host "-----------------------------------"
        Write-Host "$($this.Name):$($this.Tag)".ToUpper()
        Write-Host "dockerfile  : $($this.Dockerfile)"
        Write-Host "base        : $($this.BaseImage)"
        Write-Host "platform    : $($this.Platform)"
        Write-Host "target stage: $($this.TargetStage)"
        Write-Host "-----------------------------------"   
    }
    
    [string]getNameTag() {
        return "$($this.Name):$($this.Tag)"
    }

    [void]setDefaults([hashtable]$defaults) {
        foreach ($key in $defaults.Keys) {
            if ($null -eq $this.$key) {
                $this.$key = $defaults[$key]
            }
        }
    }
}

if ($global:testing_BuildHelpers_psm1) {
    Export-ModuleMember -Function *
}
else {
    Export-ModuleMember -Function @(
        "Prompt-YesNo",
        "New-Manifest",
        "New-ManifestList"
    )
}