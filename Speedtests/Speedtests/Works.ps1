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
$bulkCopy.DestinationTableName = "Works"
$bulkCopy.BatchSize = $batchsize

# Create the Datatable
$datatable = New-Object System.Data.DataTable

# Add generic columns instead
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
	# Split line into an array
	$data = $line.Split($delimiter)
	
	# Create new row
	$row = $datatable.NewRow()

	# Populate the row
	$row.Item("GeoNameId") = $data[0]
	$row.Item("Name") = $data[1]
	$row.Item("AsciiName") = $data[2]
	$row.Item("AlternateNames") = $data[3]
	$row.Item("Latitude") = $data[4]
	$row.Item("Longitude") = $data[5]
	$row.Item("FeatureClass") = $data[6]
	$row.Item("FeatureCode") = $data[7]
	$row.Item("CountryCode") = $data[8]
	$row.Item("Cc2") = $data[9]
	$row.Item("Admin1Code") = $data[10]
	$row.Item("Admin2Code") = $data[11]
	$row.Item("Admin3Code") = $data[12]
	$row.Item("Admin4Code") = $data[13]
	$row.Item("Population") = $data[14]
	$row.Item("Elevation") = $data[15]
	$row.Item("Dem") = $data[16]
	$row.Item("Timezone") = $data[17]
	$row.Item("ModificationDate") = $data[18]

	# Add row to datatable
	$datatable.Rows.Add($row)  
	
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
