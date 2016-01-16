# MILLION ROW CSV file
$csv = ".\geonames.csv"
$delimiter = "`t"

# Create the Datatable
$datatable = New-Object System.Data.DataTable

#  Add columns to the datatable
$null = $datatable.Columns.Add("GeoNameId")
$null = $datatable.Columns.Add("Name")
$null = $datatable.Columns.Add("AsciiName")
$null = $datatable.Columns.Add("AlternateNames")
$null = $datatable.Columns.Add("Latitude")
$null = $datatable.Columns.Add("Longitude")
$null = $datatable.Columns.Add("FeatureClass")
$null = $datatable.Columns.Add("FeatureCode")
$null = $datatable.Columns.Add("CountryCode")
$null = $datatable.Columns.Add("Cc2")
$null = $datatable.Columns.Add("Admin1Code")
$null = $datatable.Columns.Add("Admin2Code")
$null = $datatable.Columns.Add("Admin3Code")
$null = $datatable.Columns.Add("Admin4Code")
$null = $datatable.Columns.Add("Population")
$null = $datatable.Columns.Add("Elevation")
$null = $datatable.Columns.Add("Dem")
$null = $datatable.Columns.Add("Timezone")
$null = $datatable.Columns.Add("ModificationDate")

<#
CREATE TABLE [dbo].[allcountries](
	[GeoNameId] nvarchar(255) PRIMARY KEY,
	[Name] nvarchar(max),
	[AsciiName] nvarchar(max),
	[AlternateNames] nvarchar(max),
	[Latitude] nvarchar(max),
	[Longitude] nvarchar(max),
	[FeatureClass] nvarchar(max),
	[FeatureCode] nvarchar(max),
	[CountryCode] nvarchar(max),
	[Cc2] nvarchar(max),
	[Admin1Code] nvarchar(max),
	[Admin2Code] nvarchar(max),
	[Admin3Code] nvarchar(max),
	[Admin4Code] nvarchar(max),
	[Population] nvarchar(max),
	[Elevation] nvarchar(max),
	[Dem] nvarchar(max),
	[Timezone] nvarchar(max),
	[ModificationDate] nvarchar(max)
) 
#>

# Open the text file from disk and process.
$reader = New-Object System.IO.StreamReader($csv)

while (($line = $reader.ReadLine()) -ne $null)
{
	# EVERYTHING HERE RUNS ONE MILLION TIMES!

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
}

# Close the file
$reader.Close()

# Build the bulk server connection
$connstring = "Data Source=localhost;Integrated Security=true;Initial Catalog=Presentation;"
$bulkcopy = New-Object Data.SqlClient.SqlBulkCopy($connstring)
$bulkCopy.BulkCopyTimeout = 0
$bulkCopy.DestinationTableName = "allcountries"

# Perform the actual insert
$bulkCopy.WriteToServer($datatable)

# Dispose of the datatable
$datatable.Dispose()