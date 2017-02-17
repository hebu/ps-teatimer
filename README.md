# PowerShell Tee-Uhr

## Installation

1. Dieses Repository klonen
2. PowerShell öffnen, Execution Policy für Skripte erlauben

		Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
		
3. Das PowerShell Profil bearbeiten: `%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`
4. Folgenden Alias hinzufügen (Pfad anpassen):

		function tea() {
			param (
				[Parameter(Mandatory=$true,HelpMessage="Time to elapse until tea is ready.")]
				[string]
				$timespan
			)
			
			C:\Scripts\TeeUhr\tea.ps1 $timespan
		}
		
5. PowerShell erneut öffnen, Tee-Uhr mit dem Befehl `tea 00:00` von überall her starten.
6. Hilfe zur Benutzung mit `tea help`
