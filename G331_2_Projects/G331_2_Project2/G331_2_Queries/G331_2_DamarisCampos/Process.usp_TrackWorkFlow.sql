SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Damaris
-- Create date: 4/12/24
-- Description:	Track work flow
-- =============================================
ALTER   PROCEDURE [Process].[usp_TrackWorkFlow]
    -- Add the parameters for the stored procedure here
    @WorkflowDescription NVARCHAR(100),
    @WorkFlowStepTableRowCount INT,
    @StartingDateTime DATETIME2,
    @EndingDateTime DATETIME2,
    @UserAuthorizationKey INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [Process].[WorkflowSteps]
    (
        WorkFlowStepDescription,
        WorkFlowStepTableRowCount,
        StartingDateTime,
        EndingDateTime,
        [Class Time],
        UserAuthorizationKey
    )
    VALUES
    (@WorkflowDescription, @WorkFlowStepTableRowCount, @StartingDateTime, @EndingDateTime, '7:45',
     @UserAuthorizationKey);

END;
GO
