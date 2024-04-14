SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damaris
-- Create date: 4/13/24
-- Description:	Show workflow steps
-- =============================================
ALTER PROCEDURE [Process].[usp_ShowWorkflowSteps] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT *
	FROM [Process].[WorkFlowSteps];
END
GO
