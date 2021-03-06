USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[cancelWorkshopReservation]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




Create Procedure [dbo].[cancelWorkshopReservation](
	@WorkshopReservationID int
) AS BEGIN
  SET NOCOUNT ON;  
		IF @WorkshopReservationID is null 
			THROW 51000, '@WorkshopReservationID is null', 1
		
		Declare @id int
		Select @id =  (Select WorkshopReservations.WorkshopReservationID from WorkshopReservations where WorkshopReservationID = @WorkshopReservationID and isCanceled = 0 )
		IF @id is null 
			THROW 51000, 'WorkshopReservation with given Id does not exist ', 1
		
		Declare @date smalldatetime
		Select @date =  (Select reservationDate from WorkshopReservations where WorkshopReservationID = @WorkshopReservationID)
		IF DateDiff(day, @date , getdate()) >= 7  
			THROW 51000, 'WorkshopReservation is overdue', 1
		
		Declare @paid bit 
		select @paid =  (Select WorkshopReservations.Paid from WorkshopReservations where WorkshopReservationID = @WorkshopReservationID)
		IF @paid = 1 
			THROW 51000, 'WorkshopReservation has been already paid', 1

		Update WorkshopReservations
		set isCanceled =  1
		where WorkshopReservationID = @WorkshopReservationID
END  
GO
