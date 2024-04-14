SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Evnul
-- Create date: 4/13/24
-- Description:	Loads data into [Project2].[ShowTableStatusRowCount]
-- =============================================

ALTER PROCEDURE [Project2].[ShowTableStatusRowCount] @TableStatus VARCHAR(64), @UserAuthorizationKey INT 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    DECLARE @EndingDateTime DATETIME2;


    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;

    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimCustomer',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimCustomer
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimGender',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimGender
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimMaritalStatus',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimMaritalStatus
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimOccupation',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimOccupation
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimOrderDate',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimOrderDate
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProduct',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimProduct
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProductCategory',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimProductCategory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimProductSubcategory',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimProductSubcategory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.DimTerritory',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].DimTerritory
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Dimension.SalesManagers',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Dimension].SalesManagers
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'CH01-01-Fact.Data',
           [Row Count] = COUNT(*)
    FROM [CH01-01-Fact].[Data]
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'DbSecurity.UserAuthorization',
           [Row Count] = COUNT(*)
    FROM [DbSecurity].UserAuthorization
    UNION ALL
    SELECT TableStatus = @TableStatus,
           TableName = 'Process.WorkflowSteps',
           [Row Count] = COUNT(*)
    FROM [Process].WorkflowSteps;

    SET @EndingDateTime = SYSDATETIME();

    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project2].[ShowStatusRowCount] loads data into [Project2].[ShowTableStatusRowCount]',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;

END
GO
