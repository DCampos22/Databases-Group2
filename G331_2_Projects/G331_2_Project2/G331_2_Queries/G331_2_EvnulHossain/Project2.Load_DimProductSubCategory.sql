SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damaris
-- Create date: 4/13/24
-- Description:	Populating ProductSubCategory Table
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;


    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimProductSubCategory]
    (
        ProductCategoryKey,
        ProductSubcategory,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT DISTINCT
           DPC.ProductCategoryKey,
           OLD.ProductSubcategory,
           @UserAuthorizationKey,
           @DateAdded,
           @DateOfLastUpdate
    FROM FileUpload.OriginallyLoadedData AS OLD
        FULL JOIN [CH01-01-Dimension].[DimProductCategory] AS DPC
            ON OLD.[ProductCategory] = DPC.[ProductCategory];

    ---VIEW for NEW Table---
    EXEC ('
    DROP VIEW IF EXISTS G7_2.uvw_DimProductSubCategory');
    EXEC ('
    CREATE VIEW G7_2.uvw_DimProductSubCategory AS
    SELECT ProductSubCategoryKey, ProductCategoryKey, ProductSubcategory, UserAuthorizationKey, DateAdded, DateOfLastUpdate
    FROM [CH01-01-Dimension].[DimProductSubCategory] ');
    ---VIEW for NEW Table--

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount =
    (
        SELECT COUNT(*) FROM [CH01-01-Dimension].DimProductSubCategory
    );

    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project2].[Load_DimProductSubCategory]  loads data into [CH01-01-Dimension].[DimProductSubCategory]',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;

    SELECT *
    FROM G7_2.uvw_DimProductSubCategory;
END;
GO
