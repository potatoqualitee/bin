# Set CSV attributes
$csv = ".\customers.csv"
$delimiter = "`t"

# Set connstring
$connstring = "Data Source=localhost;Integrated Security=true;Initial Catalog=PresentationOptimized;PACKET SIZE=32767;"

# Set batchsize to 2000
$batchsize = 2000

# Create the datatable
$datatable = New-Object System.Data.DataTable

# Add generic columns
$columns = (Get-Content $csv -First 1).Split($delimiter) 
foreach ($column in $columns) { 
	[void]$datatable.Columns.Add()
}

# Setup runspace pool and the scriptblock that runs inside each runspace
$pool = [RunspaceFactory]::CreateRunspacePool(1,5)
$pool.ApartmentState = "MTA"
$pool.Open()
$runspaces = @()

# This is the workhorse. Think of it as a function.
$scriptblock = {
   Param (
	[string]$connstring,
	[object]$dtbatch,
	[int]$batchsize
   )
   
	$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connstring,"TableLock")
	$bulkcopy.DestinationTableName = "Runspaces"
	$bulkcopy.BatchSize = $batchsize
	$bulkcopy.WriteToServer($dtbatch)
	$bulkcopy.Close()
	$dtbatch.Clear()
	$bulkcopy.Dispose()
	$dtbatch.Dispose()
}

# Start timer
$time = [System.Diagnostics.Stopwatch]::StartNew()

# Open the text file from disk and process.
$reader = New-Object System.IO.StreamReader($csv)

Write-Output "Starting insert.."

while (($line = $reader.ReadLine()) -ne $null)
{
	[void]$datatable.Rows.Add($line.Split($delimiter))

	if ($datatable.rows.count % $batchsize -eq 0) 
	{
	   $runspace = [PowerShell]::Create()
	   [void]$runspace.AddScript($scriptblock)
	   [void]$runspace.AddArgument($connstring)
	   [void]$runspace.AddArgument($datatable.Copy()) # <-- copy datatable
	   [void]$runspace.AddArgument($batchsize)
	   $runspace.RunspacePool = $pool
	   $runspaces += [PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke() }
	   $datatable.Clear() # <-- clear datatable
	}
}

# Close the file
$reader.Close()

# Wait for runspaces to complete
while ($runspaces.Status.IsCompleted -notcontains $true) {}

# End timer
$secs = $time.Elapsed.TotalSeconds

# Cleanup runspaces 
foreach ($runspace in $runspaces ) { 
	[void]$runspace.Pipe.EndInvoke($runspace.Status) # EndInvoke method retrieves the results of the asynchronous call
	$runspace.Pipe.Dispose()
}

# Cleanup runspace pool
$pool.Close() 
$pool.Dispose()

# Cleanup SQL Connections
[System.Data.SqlClient.SqlConnection]::ClearAllPools()
	
# Done! Format output then display
$totalrows = 1000000
$rs = "{0:N0}" -f [int]($totalrows / $secs)
$rm = "{0:N0}" -f [int]($totalrows / $secs * 60)
$mill = "{0:N0}" -f $totalrows

Write-Output "$mill rows imported in $([math]::round($secs,2)) seconds ($rs rows/sec and $rm rows/min)"	