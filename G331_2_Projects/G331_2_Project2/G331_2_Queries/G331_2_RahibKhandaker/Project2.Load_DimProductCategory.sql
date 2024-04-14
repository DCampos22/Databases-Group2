SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rahib
-- Create date: 4/13/24
-- Description:	Populating Product Category Table
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductCategory] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimProductCategory]
    (
        ProductCategory,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT DISTINCT
           FileUpload.OriginallyLoadedData.[ProductCategory],
           @UserAuthorizationKey,
           @DateAdded,
           @DateOfLastUpdate
    FROM FileUpload.OriginallyLoadedData;

    ---VIEW for NEW Table---
    EXEC ('
	DROP VIEW IF EXISTS G7_2.uvw_DimProductCategory');
    EXEC ('
	CREATE VIEW G7_2.uvw_DimProductCategory AS
	SELECT ProductCategoryKey, ProductCategory, UserAuthorizationKey, DateAdded, DateOfLastUpdate
	FROM [CH01-01-Dimension].[DimProductCategory] ');
    --====================

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount =
    (
        SELECT COUNT(*) FROM [CH01-01-Dimension].DimProductCategory
    );

    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project2].[Load_DimProductCategory] loads data into [CH01-01-Dimension].[DimProductCategory]',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;

    SELECT *
    FROM G7_2.uvw_DimProductCategory;



END
GO
