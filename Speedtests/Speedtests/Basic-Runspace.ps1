# STEP 1: Create and open runspace pool, setup runspaces array
$pool = [RunspaceFactory]::CreateRunspacePool(1,5)
$pool.ApartmentState = "MTA"
$pool.Open()
$runspaces = @()
	
# STEP 2: Create reusable scriptblock. This is the workhorse of the runspace. Think of it as a function.
$scriptblock = {
	Param (
	[string]$connectionString,
	[object]$dtbatch,
	[int]$batchsize
	)
	   
	$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connectionstring,"TableLock")
	$bulkcopy.DestinationTableName = "mytable"
	$bulkcopy.BatchSize = $batchsize
	$bulkcopy.WriteToServer($dtbatch)
	$bulkcopy.Close()
	$dtbatch.Clear()
	$bulkcopy.Dispose()
	$dtbatch.Dispose()

	# return whatever you want, or don't.
	return $error[0]
}

# STEP 3: Create runspace and add to runspace pool
if ($datatable.rows.count % $batchsize -eq 0) {
    $runspace = [PowerShell]::Create()
    $null = $runspace.AddScript($scriptblock)
    $null = $runspace.AddArgument($datatable.Copy())
    $null = $runspace.AddArgument($batchsize)
    $runspace.RunspacePool = $pool

# STEP 4: Add runspace to runspaces collection
	$runspaces += [PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke() }
	$datatable.Clear()
}

# STEP 5: Wait for runspaces to finish
 while ($runspaces.Status.IsCompleted -notcontains $true) {}

# STEP 6: Clean up
foreach ($runspace in $runspaces ) { 
	$results = $runspace.Pipe.EndInvoke($runspace.Status)
	$runspace.Pipe.Dispose()
}
	
$pool.Close() 
$pool.Dispose()

# Bonus step 7
# Look at $results to see any errors 