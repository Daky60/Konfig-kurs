Function Select-Process {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("start", "stop", "status", ErrorMessage="Try {1} instead")]
        [String]$Action="status",
        [Parameter(Mandatory=$true, ValueFromPipeline)]
        [String]$Process
    )
    PROCESS
    {
        $checkProcess = Get-Process $Process -ErrorAction SilentlyContinue
        try {
            switch ($Action) {
                start {
                    ## if process not found
                    if (!$checkProcess) {
                        $ProcessID = Start-Process -FilePath $Process -ErrorAction Stop -PassThru  | Select-Object -ExpandProperty Id
                        $result = "$Process with PID $ProcessID started"
                    }
                    ## if process already running, allow opening another
                    elseif ($checkProcess.count -gt 0) {
                        $PROMPT = Read-Host "$Process is already running`nDo you want to open a new window? (Y | N)"
                        switch ($PROMPT) {
                            Y {
                                $ProcessID = Start-Process -FilePath $Process -ErrorAction Stop -PassThru  | Select-Object -ExpandProperty Id
                                $result = "$Process with PID $ProcessID started"
                            }
                            N {
                                $result = "Exiting"
                            }
                        }
                    }
                    else {
                        $result = "$Process doesn't exist"
                    }
                }
                stop {
                    if ($checkProcess) {
                        if ($checkProcess.count -gt 1) {
                            $checkProcess
                            $PROMPT = Read-Host "Enter PID"
                            ## kill all
                            if ($PROMPT -eq -1) {
                                $checkProcess | Stop-Process -ErrorAction Stop
                            }
                            ## kill specific process
                            else {
                            Stop-Process -Id $PROMPT -ErrorAction Stop
                            }
                        }
                        ## if single process
                        else {
                            $checkProcess | Stop-Process -ErrorAction Stop -Confirm
                        }
                        $result = "$Process stopped"
                    }
                    else {
                        $result = "$Process not running"
                    }
                }
                status {
                    if (!$checkProcess) {
                        $result = "$Process not running"
                    }
                    else {
                        $result = $checkProcess
                    }
                }
            }
        }
        catch {
            Write-Warning $_.Exception
            exit
        }
    }
    END
    {
        $result
    }
}

"notepad" | Select-Process start