# This is a USB Deliverable Version of the Desktop Goose Prank
#-----------------------------------------------------------------------------------------------------------------------------------------
# Description:
# - Creates a hidden folder called "ImportSys" in root folder, inserts Desktop Goose files from USB into this folder, and sets a scheduled
#   task to run desktop goose - Default task time settings: -Starts everyday at 9am -Repeats task every 15min -tasks older than 2hours are killed
# Requirments:
# - USB with Desktop Goose on it
# - Needs to be run in a PowerShell with administrator privileges
# - Correct path configuration
# Known Issues:
# - Will not run correctly if pathing is incorrect
# - If downloaded to a usb pathing needs to be updated manually
# - Will show error stating that you cannot move Mods folder from desktop goose - disregard - this folder is not important unless you want mods.
#-----------------------------------------------------------------------------------------------------------------------------------------

# Start of Script
#-------------------------------------------------------------#
# Directory Traversal + Creation + Modification + File Transfer into hidden "ImportSys" Folder
#------------------------------#
    # Move to root folder + Create "ImportSys"
    Set-Location "C:\"
    
    # Specify the path where you want to create the folder
    $folderPath = "C:\ImportSys"

    # Create the folder + set as hidden 
    New-Item -Path $folderPath -ItemType Directory
    Set-ItemProperty -Path "C:\ImportSys" -Name "Attributes" -Value ([System.IO.FileAttributes]::Hidden)

    # Define the source and destination paths
    $sourcePath = "D:\Desktop Goose v0.31"
    $destinationPath = "C:\ImportSys"

    # Copy Goose Files to the folder
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse

#------------------------------#
# Task Creation
#------------------------------#
  # Define Name
  $taskName = "lol"

# XML for task definition
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
      <Command>"C:\ImportSys\Desktop Goose v0.31\Desktop Goose v0.31\DesktopGoose v0.31\GooseDesktop.exe"</Command>
    </Exec>
  </Actions>
</Task>
"@

# Register scheduled task with Xml and name
Register-ScheduledTask -Xml $taskXml -TaskName $taskName
#-------------------------------------------------------------#
# End Script