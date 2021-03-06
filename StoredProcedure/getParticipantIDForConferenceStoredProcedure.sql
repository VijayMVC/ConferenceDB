USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[getParticipantIDForConference]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure  [dbo].[getParticipantIDForConference]   
  @ConferenceID INT
AS BEGIN   
SET NOCOUNT ON; 
	If @ConferenceID is null
		Throw 51000, '@ConferenceID is null', 1
	Declare @id int 
	Select @id = (Select ConferenceID from Conferences where ConferenceID = @ConferenceID)
	IF @id is null
		Throw 51000, 'Conference with given Id does not exist' , 1

	Select Attendee.AttendeeID, Attendee.FirstName, Attendee.LastName, isNULL(Customer.CustomerName, '') as 'Company'
	from Conferences 
	inner join ConferenceDays
	on ConferenceDays.ConferenceID = Conferences.ConferenceID
	and Conferences.ConferenceID =  @ConferenceID
	inner join ConferenceReservations 
	on ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
	and ConferenceReservations.Paid=1
	inner join ConferencePrincipants
	on ConferencePrincipants.ConferenceReservationID = ConferenceReservations.ConferenceReservationID
	inner join Attendee 
	on Attendee.AttendeeID = ConferencePrincipants.AttendeeID
	left join Customer 
	on Customer.CustomerID = Attendee.CustomerID
	and Customer.isCompany = 1 
END
GO
