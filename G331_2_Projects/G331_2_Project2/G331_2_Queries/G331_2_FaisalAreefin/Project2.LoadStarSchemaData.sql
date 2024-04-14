SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Areefin
-- Create date: 4/13/24
-- Description:	
-- =============================================
ALTER PROCEDURE [Project2].[LoadStarSchemaData] 
AS
BEGIN
    SET NOCOUNT ON;
		declare @UserAuthorizationKey int = 2;
	    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
 	--
    EXEC  [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 3;
	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Pre-truncate of tables'''
    --
    --	Always truncate the Star Schema Data
    --
    EXEC  [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 2;
    --
    --	Load the star schema
    --
    EXEC  [Project2].[Load_DimProductCategory] @UserAuthorizationKey = 6;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey = 6;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimProduct] @UserAuthorizationKey = 6;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_SalesManagers] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimGender] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOccupation] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOrderDate] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimTerritory] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimCustomer] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_Data] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
  --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
 	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the star schema'''
	--
   EXEC [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    --

	DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC [Process].[usp_TrackWorkFlow] 'Load Star Schema Data',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;
END;
GO
