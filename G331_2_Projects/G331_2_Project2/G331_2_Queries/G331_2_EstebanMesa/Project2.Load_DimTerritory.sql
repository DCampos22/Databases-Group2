SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Esteban
-- Create date: 4/13/24
-- Description:	Populating the Territory Table
-- =============================================

ALTER PROCEDURE [Project2].[Load_DimTerritory] @UserAuthorizationKey int 
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @DateAdded DATETIME2;
	SET @DateAdded = SYSDATETIME();

	DECLARE @DateOfLastUpdate DATETIME2;
	SET @DateOfLastUpdate = SYSDATETIME();

	DECLARE @StartingDateTime DATETIME2;
	SET @StartingDateTime = SYSDATETIME();

INSERT INTO [CH01-01-Dimension].DimTerritory
([TerritoryRegion], [TerritoryCountry], [TerritoryGroup], UserAuthorizationKey, DateAdded, DateOfLastUpdate)

SELECT DISTINCT FUp.[TerritoryRegion], FUp.[TerritoryCountry], FUp.[TerritoryGroup], @UserAuthorizationKey, @DateAdded, @DateOfLastUpdate
FROM FileUpload.OriginallyLoadedData AS FUp


    DECLARE @EndingDateTime DATETIME2;
    set @EndingDateTime = SYSDATETIME()

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*) FROM [CH01-01-Dimension].DimTerritory);

	EXEC('
    DROP VIEW IF EXISTS G7_2.uvw_DimTerritory')
    EXEC('
    CREATE VIEW G7_2.uvw_DimTerritory AS
    SELECT TerritoryKey, TerritoryGroup, TerritoryCountry, TerritoryRegion, UserAuthorizationKey, DateAdded, DateOfLastUpdate
    FROM [CH01-01-Dimension].[DimTerritory] ')
	

EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2].[Load_DimTerritory]  loads data into [CH01-01-Dimension].[DimTerritory]',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @UserAuthorizationKey


	SELECT *
	FROM G7_2.uvw_DimTerritory
	END
GO
