/*




*/


CREATE DATABASE  [Presentation]
GO
USE [Presentation]
GO
CREATE TABLE [dbo].[Works](
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
	[ModificationDate] nvarchar(max) NULL
) 

GO

CREATE TABLE [dbo].[Fast](
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
	[ModificationDate] nvarchar(max) NULL
) 

GO


CREATE DATABASE  [PresentationOptimized]
ALTER DATABASE [PresentationOptimized] MODIFY FILE ( NAME = N'PresentationOptimized', SIZE =  1GB)
ALTER DATABASE [PresentationOptimized] MODIFY FILE ( NAME = N'PresentationOptimized_log', SIZE = 10MB )
ALTER DATABASE [PresentationOptimized] SET RECOVERY SIMPLE WITH NO_WAIT
ALTER DATABASE [PresentationOptimized] SET PAGE_VERIFY NONE
ALTER DATABASE [PresentationOptimized] SET AUTO_UPDATE_STATISTICS OFF
ALTER DATABASE [PresentationOptimized] SET AUTO_CREATE_STATISTICS OFF
ALTER DATABASE [PresentationOptimized] SET AUTO_CLOSE OFF
ALTER DATABASE [PresentationOptimized] SET AUTO_SHRINK OFF
GO

Use [PresentationOptimized]
GO

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

GO

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


CREATE TABLE Runspaces (
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


CREATE TABLE EfficientRunspaces (
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