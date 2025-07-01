
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.MicrosoftOfficeHub | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.MicrosoftStickyNotes | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.People | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.PowerAutomateDesktop | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.ScreenSketch | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.Todos | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.WindowsAlarms | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers microsoft.windowscommunicationsapps | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers microsoft.windowscommunicationsapp | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.WindowsFeedbackHub | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.WindowsMaps | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.WindowsSoundRecorder | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.Xbox.TCUI | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.XboxGameOverlay | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.XboxIdentityProvider | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Clipchamp.Clipchamp | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.549981C3F5F10 | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.BingNews | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.BingSearch | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.BingWeather | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.GamingApp | Remove-AppxPackage -AllUsers
PS C:\Windows> Get-AppxPackage -AllUsers Microsoft.GetHelp | Remove-AppxPackage -AllUsers
Microsoft.Windows.Cortana (command: Get-AppxPackage -AllUsers Microsoft.Windows.Cortana | Remove-AppxPackage)
Microsoft.Windows.DevHome (command: Get-AppxPackage -AllUsers Microsoft.Windows.DevHome | Remove-AppxPackage) ; it's still listed so I needed to execute this command: Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name "*Windows.DevHome*" | Remove-AppxPackage -AllUsers​
Microsoft.Windows.DevHomeGitHubExtension (command: Get-AppxPackage -AllUsers Microsoft.Windows.DevHomeGitHubExtension | Remove-AppxPackage)
Microsoft.XboxGamingOverlay (command: Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage)
