Function Read-Csv {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [String]$File
    )
    PROCESS
    {
        try {
            if ($File -Like "*.csv") {
                Import-Csv -Delimiter ";" $File
                foreach ($i in $File) {
                    $i
                }
            }
            else {
                Write-Warning "Not a CSV file"
            }
        }
        catch {
            Write-Warning $_.Exception
        }
    }
}

"test.csv" | Read-Csv