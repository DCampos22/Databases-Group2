SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rahib
-- Create date: 4/13/24
-- Description:	Populating the Customer Table
-- =============================================
ALTER PROCEDURE [Project2].[Load_DimCustomer] @UserAuthorizationKey int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	declare @WorkFlowStepDescription nvarchar = 'Procedure: [Project2].[Load_DimCustomer]  loads data into [CH01-01-Dimension].[DimCustomer]';
	DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    
    INSERT INTO [CH01-01-Dimension].[DimCustomer] (
        CustomerName, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    SELECT DISTINCT CustomerName, @UserAuthorizationKey, @DateAdded, @DateOfLastUpdate
    FROM FileUpload.OriginallyLoadedData 
        

        ---VIEW for NEW Table---
    EXEC('
    DROP VIEW IF EXISTS G7_2.uvw_DimCustomer')
    EXEC('
    CREATE VIEW G7_2.uvw_DimCustomer AS
    SELECT CustomerKey, CustomerName, UserAuthorizationKey, DateAdded, DateOfLastUpdate
    FROM [CH01-01-Dimension].[DimCustomer] ')
    ---VIEW for NEW Table--


    DECLARE @EndingDateTime DATETIME2;
    set @EndingDateTime = SYSDATETIME()

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*) FROM [CH01-01-Dimension].DimCustomer);

    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2].[Load_DimCustomer]  loads data into [CH01-01-Dimension].[DimCustomer]',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @UserAuthorizationKey

	EXEC('SELECT * FROM G7_2.uvw_DimCustomer')

END
GO
