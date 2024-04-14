SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damaris
-- Create date: 4/13/24
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
ALTER   PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();
	DECLARE @WorkFlowStepDescription nvarchar = 'Drop Foreign Keys';

    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimCustomer;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimGender;
    ALTER TABLE [CH01-01-Fact].[Data]
    DROP CONSTRAINT FK_Data_DimMaritalStatus;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimOccupation;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimOrderDate;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimProduct;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_DimTerritory;
    ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT FK_Data_SalesManagers;
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    DROP CONSTRAINT FK_DimProduct_DimProductSubCategory;
    ALTER TABLE [CH01-01-Dimension].[DimProductSubCategory]
    DROP CONSTRAINT FK_DimProductSubCategory_DimProductCategory;
    

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC [Process].[usp_TrackWorkFlow] 'Drop Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;

END;
GO
