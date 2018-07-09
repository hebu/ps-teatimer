# ------------------------------------------------------------------------------------------------------------------------------------
# Beispiele fuer 30 Sekunden:
#  tea 0:30
#  tea 0.30
#  tea 0030
#  tea 030
# ------------------------------------------------------------------------------------------------------------------------------------

param (
	[Parameter(Mandatory=$true,HelpMessage="Time to elapse until tea is ready.")]
	[string]
	$timespan
)

# ------------------------------------------------------------------------------------------------------------------------------------

# Inspiriert von http://stackoverflow.com/questions/19846692/how-to-make-a-messagebox-appear-at-a-specific-time-in-powershell
# New-Alarm -minutes 0 -seconds 10 -alertBoxTitle "Ha" -alertBoxMessage "hu"
function New-Alarm
{
	param(
        [Parameter(Mandatory=$true,HelpMessage="Enter minutes until alarm.")]
        [String]
        $minutes,
		
		[Parameter(Mandatory=$true,HelpMessage="Enter seconds until alarm.")]
        [String]
        $seconds,

        [Parameter(Mandatory=$true,HelpMessage="Enter the alert box title.")]
        [String]
        $alertBoxTitle,

        [Parameter(Mandatory=$true,HelpMessage="Enter the alert message.")]
        [String]
        $alertBoxMessage
    )

	# Load assembly
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")  > $null
	
	$startTime = get-date;
	$goalSeconds = [int]$minutes * 60 + [int]$seconds;
    do 
    {
        Start-Sleep -Seconds 1
		$nowTime = get-date
		$timespan = ($nowTime - $startTime)
		
		$status = "{0:mm}:{0:ss}" -f $timespan
		
		if (($timespan.Seconds % 5) -eq 0) {
			Write-Verbose ("{0} -- {1} >= {2} = {3}" -f $status, $timespan.TotalSeconds, $goalSeconds, $($timespan.Seconds -ge $goalSeconds));
		}
		
		$percentage = ([int][Math]::Floor($timespan.TotalSeconds) / $goalSeconds * 100)
		if ($percentage -gt 100) {
			$percentage = 100
		}
		Write-Progress -Activity "Tick tick tick ..." -status "$status" -percentComplete $percentage
    }
    until($timespan.TotalSeconds -ge $goalSeconds)
	
    # Display alert
	[Microsoft.VisualBasic.Interaction]::MsgBox($alertBoxMessage, "OKOnly,SystemModal,Exclamation", "[$(get-date -Format HH:mm)] $alertBoxTitle")
}


# ------------------------------------------------------------------------------------------------------------------------------------

Write-Host;
Write-Host "===============================================================================================";
Write-Host "===                                                                                         ===";
Write-Host "===                          P O W E R S H E L L - T E E - U H R                            ===";
Write-Host "===                                    (C) 2017 HeBu                                        ===";
Write-Host "===                                                                                         ===";
Write-Host "===============================================================================================";
Write-Host;

Write-Verbose "Verbose mode.";

if ($timespan -match "^(\d+)[\:\.](\d\d)$" -or $timespan -match "^(\d\d)(\d\d)$" -or $timespan -match "^(\d)(\d\d)$") {
	$minutes = [int]$Matches[1];
	$seconds = [int]$Matches[2];
} elseif ($timespan -match "^(\d\d)$") {
	$minutes = 0;
	$seconds = [int]$Matches[1];
} elseif ($timespan -match "^(\d)$") {
	$minutes = [int]$Matches[1];
	$seconds = 0;
} else {
	Write-Host;
	Write-Host("Aufruf:");
	Write-Host;
	Write-Host("	tea mm:ss   -oder-    tea mm.ss    -oder-    tea mmss");
	Write-Host;
	Write-Host("Kurzformen:");
	Write-Host("	tea mss			fuer einstellige Minuten und Sekunden");
	Write-Host("	tea ss			fuer zweistellige Sekunden");
	Write-Host("	tea m			fuer einstellige Minuten");
	Write-Host;
	Write-Host("Beispiele (fuer 30 Sekunden):");
	Write-Host("	tea 0:30");
	Write-Host("	tea 0.30");
	Write-Host("	tea 0030");
	Write-Host("	tea 030");
	Write-Host("	tea 30");
	Write-Host;
	Write-Host("  2 Minuten: tea 2");
	Write-Host("  5 Minuten: tea 5");
	Write-Host(" 10 Minuten: tea 10:00");
	Write-Host("120 Minuten: tea 120:00");
	Write-Host;
	break;
}

$timeString = "$($minutes):$($seconds.ToString(`"00`"))";
Write-Host;
Write-Host "Starte Tee-Uhr mit $timeString ...";
Write-Host;
New-Alarm -minutes $minutes -seconds $seconds -alertBoxTitle "TEE-ALARM!" -alertBoxMessage "              DER TEE IST FERTIG!              ";

# ------------------------------------------------------------------------------------------------------------------------------------