SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Esteban
-- Create date: 4/13/24
-- Description:	Populating the Sales Managers Table
-- =============================================

ALTER PROCEDURE [Project2].[Load_SalesManagers] @UserAuthorizationKey int

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DateAdded DATETIME2;
	SET @DateAdded = SYSDATETIME();

	DECLARE @DateOfLastUpdate DATETIME2;
	SET @DateOfLastUpdate = SYSDATETIME();

	DECLARE @StartingDateTime DATETIME2;
	SET @StartingDateTime = SYSDATETIME();


INSERT INTO [CH01-01-Dimension].[SalesManagers]
(SalesManager, Category, UserAuthorizationKey, DateAdded, DateOfLastUpdate)

SELECT DISTINCT FileUpload.OriginallyLoadedData.[SalesManager], FileUpload.OriginallyLoadedData.[ProductSubcategory] ,@UserAuthorizationKey, @DateAdded, @DateOfLastUpdate
FROM FileUpload.OriginallyLoadedData

UPDATE [CH01-01-Dimension].[SalesManagers]
SET Office = 'Redmond'
WHERE SalesManager = 'Maurizio Macagno' OR SalesManager = 'Marco Russo';

UPDATE [CH01-01-Dimension].[SalesManagers]
SET Office = 'Seattle'
WHERE SalesManager = 'Alberto Ferrari' OR SalesManager = 'Luis Bonifaz';

    DECLARE @EndingDateTime DATETIME2;
    set @EndingDateTime = SYSDATETIME()

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*) FROM [CH01-01-Dimension].SalesManagers);

----New Table View----

	EXEC('
    DROP VIEW IF EXISTS G7_2.uvw_SalesManagers')
    EXEC('
    CREATE VIEW G7_2.uvw_SalesManagers AS
    SELECT SalesManagerKey, SalesManager, Category, Office, UserAuthorizationKey, DateAdded, DateOfLastUpdate
    FROM [CH01-01-Dimension].[SalesManagers] ')

----New Table View----

    EXEC [Process].[usp_TrackWorkFlow]
        'Procedure: [Project2].[Load_SalesManagers]  loads data into [CH01-01-Dimension].[SalesManagers]',
        @WorkFlowStepTableRowCount,
        @StartingDateTime,
        @EndingDateTime,
        @UserAuthorizationKey


	SELECT *
	FROM G7_2.uvw_SalesManagers
END
GO
