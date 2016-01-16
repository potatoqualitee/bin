-- More accurate data types
CREATE TABLE SQLMods (
	[GeoNameId] [int],
	[Name] [nvarchar](200),
	[AsciiName] [nvarchar](200),
	[AlternateNames] [nvarchar](max),
	[Latitude] [float],
	[Longitude] [float],
	[FeatureClass] [char](1),
	[FeatureCode] [varchar](10),
	[CountryCode] [char](2),
	[Cc2] [varchar](255),
	[Admin1Code] [varchar](20),
	[Admin2Code] [varchar](80),
	[Admin3Code] [varchar](20),
	[Admin4Code] [varchar](20),
	[Population] [bigint],
	[Elevation] [varchar](255),
	[Dem] [int],
	[Timezone] [varchar](40),
	[ModificationDate] [smalldatetime]
)

-- Changed to dataset with no large datatypes
CREATE TABLE NoLargeVarchar (
	[CustomerId] [INT] NULL,
	[FirstName] [NVARCHAR](40) NULL,
	[LastName] [NVARCHAR](20) NULL,
	[Company] [NVARCHAR](80) NULL,
	[Address] [NVARCHAR](70) NULL,
	[City] [NVARCHAR](40) NULL,
	[State] [VARCHAR](40) NULL,
	[Country] [VARCHAR](40) NULL,
	[PostalCode] [VARCHAR](10) NULL,
	[Phone] [VARCHAR](24) NULL,
	[Fax] [VARCHAR](24) NULL,
	[Email] [VARCHAR](60) NULL
)