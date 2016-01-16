# Set CSV attributes
$csv = ".\geonames.csv"
$delimiter = "`t"

# Set batchsize
$batchsize = 50000

# Build the bulk server connection
$connstring = "Data Source=localhost;Integrated Security=true;Initial Catalog=PresentationOptimized;"
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connstring,"TableLock")
$bulkCopy.BulkCopyTimeout = 0
$bulkCopy.DestinationTableName = "SQLMods"
$bulkCopy.BatchSize = $batchsize

# Create the datatable
$datatable = New-Object System.Data.DataTable

# Add generic columns
$columns = (Get-Content $csv -First 1).Split($delimiter) 
foreach ($column in $columns) { 
	$null = $datatable.Columns.Add()
}

# Start timer
$time = [System.Diagnostics.Stopwatch]::StartNew()

# Open the text file from disk
$reader = New-Object System.IO.StreamReader($csv)

# Process each line
while (($line = $reader.ReadLine()) -ne $null -and ++$i)
{
	
	# Add row
	$null = $datatable.Rows.Add($line.Split($delimiter))

	# if the batch size is reached, WriteToServer, then clear datatable
	if ($datatable.rows.count % $batchsize -eq 0)
	{
		$bulkCopy.WriteToServer($datatable)
		$datatable.Clear()

		$rowsec = "{0:N0}" -f [int]$($i / $time.Elapsed.TotalSeconds)
		$secs ="{0:N2}" -f $time.Elapsed.TotalSeconds
		Write-Output "$i rows written in $secs seconds ($rowsec rows/sec)"
		
	}

}

# Close the file
$reader.Close()

# End timer
$secs = $time.Elapsed.TotalSeconds

# Done! Format output then display
$totalrows = 1000000
$rs = "{0:N0}" -f [int]($totalrows / $secs)
$rm = "{0:N0}" -f [int]($totalrows / $secs * 60)
$mill = "{0:N0}" -f $totalrows

Write-Output "$mill rows imported in $([math]::round($secs,2)) seconds ($rs rows/sec and $rm rows/min)"	