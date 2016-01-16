# Set CSV attributes
$csv = ".\geonames.csv"
$delimiter = "`t"

# Set batchsize to 50000
$batchsize = 50000

# Set connection string
$connstring = "Data Source=localhost;Integrated Security=true;Initial Catalog=Presentation;"

# Stage the bulk server connection
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connstring)
$bulkCopy.BulkCopyTimeout = 0
$bulkCopy.DestinationTableName = "Fast"
$bulkCopy.BatchSize = $batchsize

# Create the Datatable
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
	<# First I used ItemArray 
	$row = $datatable.NewRow() 
	$row.ItemArray = $line.Split($delimiter)
	$datatable.Rows.Add($row)
	#>
	
	# Add row in one fell swoop
	$null = $datatable.Rows.Add($line.Split($delimiter))

	# if the batch size is reached, WriteToServer, then clear datatable
	if ($datatable.rows.count % $batchsize -eq 0)
	{
		# This runs 20 times (1000000/50000)
		$bulkCopy.WriteToServer($datatable)
		$datatable.Clear()

		# Show rows/sec
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