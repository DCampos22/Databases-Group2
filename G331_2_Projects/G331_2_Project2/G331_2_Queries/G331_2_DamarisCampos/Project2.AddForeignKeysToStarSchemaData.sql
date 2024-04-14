SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damaris
-- Create date: 4/13/24
-- Description:	Adding Foreign Keys From the Star Schema
-- =============================================
ALTER   PROCEDURE [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.

	
	declare @WorkFlowStepDescription nvarchar;
    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimCustomer
        FOREIGN KEY (CustomerKey)
        REFERENCES [CH01-01-Dimension].DimCustomer (CustomerKey);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimGender
        FOREIGN KEY (Gender)
        REFERENCES [CH01-01-Dimension].DimGender (Gender);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimMaritalStatus
        FOREIGN KEY (MaritalStatus)
        REFERENCES [CH01-01-Dimension].DimMaritalStatus (MaritalStatus);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimOccupation
        FOREIGN KEY (OccupationKey)
        REFERENCES [CH01-01-Dimension].DimOccupation (OccupationKey);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimOrderDate
        FOREIGN KEY (OrderDate)
        REFERENCES [CH01-01-Dimension].DimOrderDate (OrderDate);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimProduct
        FOREIGN KEY (ProductKey)
        REFERENCES [CH01-01-Dimension].DimProduct (ProductKey);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_DimTerritory
        FOREIGN KEY (TerritoryKey)
        REFERENCES [CH01-01-Dimension].DimTerritory (TerritoryKey);
    ALTER TABLE [CH01-01-Fact].[Data]
    ADD CONSTRAINT FK_Data_SalesManagers
        FOREIGN KEY (SalesManagerKey)
        REFERENCES [CH01-01-Dimension].SalesManagers (SalesManagerKey);
    ALTER TABLE [CH01-01-Dimension].[DimProduct]
    ADD CONSTRAINT FK_DimProduct_DimProductSubCategory
        FOREIGN KEY (ProductSubcategoryKey)
        REFERENCES [CH01-01-Dimension].DimProductSubCategory (ProductSubCategoryKey);
    ALTER TABLE [CH01-01-Dimension].[DimProductSubCategory]
    ADD CONSTRAINT FK_DimProductSubCategory_DimProductCategory
        FOREIGN KEY (ProductCategoryKey)
        REFERENCES [CH01-01-Dimension].DimProductCategory (ProductCategoryKey);
    

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC [Process].[usp_TrackWorkFlow] 'Add Foreign Keys',
                                       @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @UserAuthorizationKey;
END;
GO
