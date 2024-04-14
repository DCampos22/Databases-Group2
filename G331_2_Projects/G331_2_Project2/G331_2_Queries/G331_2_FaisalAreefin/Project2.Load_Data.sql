SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Areefin
-- Create date: 4/13/24
-- Description:	Populating the Data Table
--
--
-- =============================================
ALTER PROCEDURE [Project2].[Load_Data] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
	
	SET @UserAuthorizationKey = 2;
    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [CH01-01-Fact].[Data] (
		SalesKey,
		SalesManagerKey,
		OccupationKey,
		TerritoryKey,
		ProductKey,
		CustomerKey,
		ProductCategory,
		SalesManager,
		ProductSubcategory,
		ProductCode,
		ProductName,
		Color,
		ModelName,
		OrderQuantity,
		UnitPrice,
		ProductStandardCost,
		SalesAmount,
		OrderDate,
		[MonthName],
		MonthNumber,
		[Year],
		CustomerName,
		MaritalStatus,
		Gender,
		Education,
		Occupation,
		TerritoryRegion,
		TerritoryCountry,
		TerritoryGroup,
		UserAuthorizationKey,
		DateAdded,
		DateOfLastUpdate
		)
	SELECT DISTINCT 
		old.Saleskey,
		sm.SalesManagerKey,
		do.OccupationKey,
		dt.TerritoryKey,
		dp.ProductKey,
		dc.CustomerKey,
		old.ProductCategory,
		old.SalesManager,
		old.ProductSubcategory,
		old.ProductCode,
		old.ProductName,
		old.Color,
		old.ModelName,
		old.OrderQuantity,
		old.UnitPrice,
		old.ProductStandardCost,
		old.SalesAmount,
		old.OrderDate,
		old.[MonthName],
		old.MonthNumber,
		old.[Year],
		old.CustomerName,
		old.MaritalStatus,
		old.Gender,
		old.Education,
		old.Occupation,
		old.TerritoryRegion,
		old.TerritoryCountry,
		old.TerritoryGroup,
		@UserAuthorizationKey,
		@DateAdded,
		@DateOfLastUpdate
	FROM 
		FileUpload.OriginallyLoadedData AS old LEFT JOIN 
		[CH01-01-Dimension].DimProduct AS dp 
								on dp.ProductName = old.ProductName AND
								   dp.ProductCode = old.ProductCode LEFT JOIN
		[CH01-01-Dimension].DimTerritory AS dt
								on dt.TerritoryCountry = old.TerritoryCountry AND
									dt.TerritoryGroup = old.TerritoryGroup AND
									dt.TerritoryRegion = old.TerritoryRegion INNER JOIN 
		[CH01-01-Dimension].DimCustomer as dc
								on dc.CustomerName = old.CustomerName LEFT JOIN 
		[CH01-01-Dimension].SalesManagers as sm
								on sm.SalesManager = old.SalesManager and
									sm.Category = old.ProductSubcategory LEFT JOIN
		[CH01-01-Dimension].DimOccupation as do
								on do.Occupation = old.Occupation 
	
    ---VIEW for NEW Table---
    EXEC ('
    DROP VIEW IF EXISTS G7_2.uvw_FactData');
    EXEC ('
    CREATE VIEW G7_2.uvw_FactData AS
    SELECT 
		Saleskey,
		SalesManagerKey,
		OccupationKey,
		TerritoryKey,
		ProductKey,
		CustomerKey,
		ProductCategory,
		SalesManager,
		ProductSubcategory,
		ProductCode,
		ProductName,
		Color,
		ModelName,
		OrderQuantity,
		UnitPrice,
		ProductStandardCost,
		SalesAmount,
		OrderDate,
		[MonthName],
		MonthNumber,
		[Year],
		CustomerName,
		MaritalStatus,
		Gender,
		Education,
		Occupation,
		TerritoryRegion,
		TerritoryCountry,
		TerritoryGroup,
		UserAuthorizationKey,
		DateAdded,
		DateOfLastUpdate
    FROM [CH01-01-Fact].[Data] ');
    ---VIEW for NEW Table--

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*) FROM [CH01-01-Fact].[Data]);

    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project2].[Load_Data]  loads data into [CH01-01-Fact].[Data]',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;


    SELECT *
    FROM G7_2.uvw_FactData;

END;


GO
