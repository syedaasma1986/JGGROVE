/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/


/****** Object:  StoredProcedure [dbo].[SwapFileOrder]    Script Date: 8/11/2018 7:54:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SwapFileOrder]  
(  
 @currentfileid int,  
 @fileToSwapid int  
)  
As  
Begin  
 declare @currentfileidDisplayOrder int   
 declare @fileToSwapidDisplayOrder int   
 set @currentfileidDisplayOrder = (select top 1 DisplayOrder from Files where ID = @currentfileid)  
 set @fileToSwapidDisplayOrder = (select top 1 DisplayOrder from Files where ID = @fileToSwapid)  
 Update Files set DisplayOrder = @fileToSwapidDisplayOrder where ID = @currentfileid  
 Update Files set DisplayOrder = @currentfileidDisplayOrder where ID = @fileToSwapid  
End  