# Set CSV attributes
$csv = ".\customers.csv"
$delimiter = "`t"

# Set batchsize
$batchsize = 50000

# Build the bulk server connection
$connstring = "Data Source=localhost;Integrated Security=true;Initial Catalog=PresentationOptimized;"
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connstring)
$bulkCopy.BulkCopyTimeout = 0
$bulkCopy.DestinationTableName = "NoLargeVarchar"
$bulkCopy.BatchSize = $batchsize

# Create the Datatable then add columns
$datatable = New-Object System.Data.DataTable

# ADD GENERIC COLUMNS INSTEAD TO MAKE IT MORE PORTABLE
$columns = (Get-Content $csv -First 1).Split("`t") 
foreach ($column in $columns) { 
	$null = $datatable.Columns.Add()
}

# Start timer
$time = [System.Diagnostics.Stopwatch]::StartNew()

# Open the text file from disk and process.
$reader = New-Object System.IO.StreamReader($csv)

while (($line = $reader.ReadLine()) -ne $null -and ++$i)
{	
	# Split line to get data from each column
	$row = $datatable.NewRow() 
	$row.itemarray = $line.Split($delimiter)
	$datatable.Rows.Add($row)   
		
	if ($datatable.rows.count % $batchsize -eq 0)
	{
		$bulkCopy.WriteToServer($datatable)
		$rowsec = "{0:N0}" -f [int]$($i / $time.Elapsed.TotalSeconds)
		$secs ="{0:N2}" -f $time.Elapsed.TotalSeconds
		Write-Output "$i rows written in $secs seconds ($rowsec rows/sec)"
		$datatable.Clear()
	}
}
# Close the file
$reader.Close()
$secs = $time.Elapsed.TotalSeconds

# Done! Format output then display
$totalrows = 1000000
$rs = "{0:N0}" -f [int]($totalrows / $secs)
$rm = "{0:N0}" -f [int]($totalrows / $secs * 60)
$mill = "{0:N0}" -f $totalrows

Write-Output "$mill rows imported in $([math]::round($secs,2)) seconds ($rs rows/sec and $rm rows/min)"	
