Describe 'BuildHelpers' {
    #  Import the script to test
    BeforeAll {
        $global:testing_BuildHelpers_psm1 = $true
        Import-Module `
            -Name (Resolve-Path ( Join-Path $PSScriptRoot './BuildHelpers.psm1')) `
            -Verbose `
            -Force
    }

    Context 'Prompt-YesNo' {
        It 'Should return true when user input is "y | Y | ye | yes"' {
            "y" | Prompt-YesNo | Should -Be $true
            "Y" | Prompt-YesNo | Should -Be $true
            "ye" | Prompt-YesNo | Should -Be $true
            "yes" | Prompt-YesNo | Should -Be $true
        }
        It 'Should return false when user input is "n | N | no | yess"' {
            "n" | Prompt-YesNo | Should -Be $false
            "N" | Prompt-YesNo | Should -Be $false
            "no" | Prompt-YesNo | Should -Be $false
            "yess" | Prompt-YesNo | Should -Be $false
        }
    }

    Context 'prependHostname' {
        It 'Should prepend the hostname to the image' {
            $image = "image1:latest"
            $hostname = "localhost:5000"
            $expected = "localhost:5000/image1:latest"
            prependHostname $hostname $image | Should -Be $expected
        }
    }

    Context 'expandList' {
        It 'Should prepend the hostname to the image list' {
            $images = @("image1", "image2", "image3")
            $hostname = "localhost:5000"
            $expected = "localhost:5000/image1 localhost:5000/image2 localhost:5000/image3"
            expandList $images -WithHostname $hostname | Should -Be $expected
        }
    }

    AfterAll {
        Remove-Variable -Name testing_BuildHelpers_psm1 -Scope Global -Force
    }
}