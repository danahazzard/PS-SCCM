
function Join-CMSoftwareUpdateGroup
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$false,
                   Position=0)]
        [string[]]$Source,

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$false,
                   Position=1)]
        [string]$Target
    )

    Begin
    {
        Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH) ConfigurationManager.psd1);

        $CurrentLocation = Get-Location;
        $SiteName = (Get-PSDrive -PSProvider CMSite).Name;

        Set-Location ($SiteName + ':');
    }
    Process
    {
        $SourceUpdates = @();

        foreach($S in $Source)
        {
            $SourceUpdates += Get-CMSoftwareUpdate -UpdateGroupName $S -Fast;
        }

        Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $Target -SoftwareUpdate $SourceUpdates;
    }
    End
    {
        Set-Location $CurrentLocation
    }
}

<#
    Example
#>
#Join-CMSoftwareUpdateGroup -Source 'SUG-2018-01','SUG-2018-02','SUG-2018-03' -Target 'SUG-Q1'
