USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[cancelConferenceReservation]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[cancelConferenceReservation](
	@ConferenceReservationID int
) AS BEGIN
  SET NOCOUNT ON;  
		IF @ConferenceReservationID is null 
			THROW 51000, '@ConferenceReservationID is null', 1
		
		Declare @id int
		Select @id =  (Select ConferenceReservationID from ConferenceReservations where ConferenceReservationID = @ConferenceReservationID and isCanceled = 0)
		IF @id is null 
			THROW 51000, 'ConferenceReservation with given Id does not exist ', 1
		
		Declare @date smalldatetime
		Select @date =  (Select ReservationDate from ConferenceReservations where ConferenceReservationID = @ConferenceReservationID)
		IF DateDiff(day, @date , getdate()) >= 7  
			THROW 51000, 'ConferenceReservation is overdue', 1
		
		Declare @paid bit 
		select @paid =  (Select Paid from ConferenceReservations where ConferenceReservationID = @ConferenceReservationID)
		IF @paid = 1 
			THROW 51000, 'ConferenceReservation has been already paid', 1

		Update ConferenceReservations
		set isCanceled =  1
		where ConferenceReservationID = @ConferenceReservationID
  
END  
GO
