SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Areefin
-- Create date: 4/13/24
-- Description:	Populating the Marital Status Table
-- =============================================


ALTER PROCEDURE [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey int 
AS
BEGIN
    SET NOCOUNT ON;

	
    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [CH01-01-Dimension].[DimMaritalStatus]
    (
        MaritalStatus,
        MaritalStatusDescription,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT DISTINCT
           MaritalStatus,
           CASE
               WHEN OLD.MaritalStatus = 'M' THEN
                   'Married'
               ELSE
                   'Single'
           END AS MaritalStatusDescription,
           @UserAuthorizationKey,
           @DateAdded,
           @DateOfLastUpdate
    FROM FileUpload.OriginallyLoadedData AS OLD;


    EXEC ('
    DROP VIEW IF EXISTS G7_2.uvw_DimMaritalStatus');
    EXEC ('
    CREATE VIEW G7_2.uvw_DimMaritalStatus AS
    SELECT MaritalStatus, MaritalStatusDescription, UserAuthorizationKey, DateAdded, DateOfLastUpdate
    FROM [CH01-01-Dimension].[DimMaritalStatus] ');
    ---VIEW for NEW Table--
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = (SELECT COUNT(*) FROM [CH01-01-Dimension].DimMaritalStatus);

    EXEC [Process].[usp_TrackWorkFlow] 'Procedure: [Project2].[Load_MaritalStatus]  loads data into [CH01-01-Dimension].[DimMaritalStatus]',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;
    SELECT * FROM G7_2.uvw_DimMaritalStatus;

END
GO
