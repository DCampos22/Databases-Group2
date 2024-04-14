SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Evnul
-- Create date: 4/13/24
-- Description:	Drop Procedures
-- =============================================
ALTER procedure [Utils].[DropProcsInCSCI331FinalProject] @UserAuthorizationKey INT
as
begin
 
    set nocount on;
	DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    --select concat('drop prodcedure if exists  ', schema_name(o.schema_id), '.', name)
    --from sys.objects as o
    --where o.type = 'P'
    --      and o.schema_id = 9;

    drop proc if exists Project2.Load_SalesManagers;
    drop proc if exists Project2.Load_DimProductSubcategory;
    drop proc if exists Project2.Load_DimProductCategory;
    drop proc if exists Project2.Load_DimGender;
    drop proc if exists Project2.Load_DimMaritalStatus;
    drop proc if exists Project2.Load_DimOccupation;
    drop proc if exists Project2.Load_DimOrderDate;
    drop proc if exists Project2.Load_DimTerritory;
    drop proc if exists Project2.Load_DimProduct;
    drop proc if exists Project2.Load_DimCustomer;
    drop proc if exists Project2.Load_Data;
    drop proc if exists Project2.TruncateStarSchemaData;
    drop proc if exists Project2.LoadStarSchemaData;

	DROP PROC IF EXISTS Project2.AddForeignKeysToStarSchemaData;
	DROP PROC IF EXISTS Project2.DropForeignKeysFromStarSchemaData;
	DROP PROC IF EXISTS Project2.ShowTableStatusRowCount;

	DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
	DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC [Process].[usp_TrackWorkFlow] 'Drop Procedures',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;
	
	DROP PROC IF EXISTS Process.usp_TrackWorkFlow;
end;
GO
