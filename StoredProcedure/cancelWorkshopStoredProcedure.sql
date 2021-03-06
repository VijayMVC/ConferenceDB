USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[cancelWorkshop]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[cancelWorkshop](
	@WorkshopID int
) AS BEGIN
  SET NOCOUNT ON;  
		IF @WorkshopID is null 
			THROW 51000, '@WorkshopID is null', 1
		
		Declare @id int
		Select @id =  (Select WorkshopID from Workshops where WorkshopID = @WorkshopID and isCanceled = 0)
		IF @id is null 
			THROW 51000, 'Workshop with given Id does not exist ', 1
		
		Declare @date smalldatetime
		Select @date =  (Select StartDate from ConferenceDays
						inner join Workshops on Workshops.ConferenceDayID= ConferenceDays.ConferenceDayID
						 where Workshops.WorkshopID = @WorkshopID)
		IF @date < getDate()  
			THROW 51000, 'Could not cancel workshop that have already started or had ended', 1

		Update Workshops
		set isCanceled =  1
		where WorkshopID = @WorkshopID
END  
GO
