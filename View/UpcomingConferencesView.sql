USE [jsroka_a]
GO
/****** Object:  View [dbo].[UpcomingConferences]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create view [dbo].[UpcomingConferences] as
select  Conferences.ConferenceID,
		Conferences.ConferenceName,
		ConferenceDays.ConferenceDayID,
		ConferenceDays.StartDate, 
		ConferenceDays.EndDate,
		min(ConferenceDays.Seats) - ISNULL(sum(ConferenceReservations.Quantity) , 0) as 'AvailableSeats'
from Conferences
inner join ConferenceDays 
on ConferenceDays.ConferenceID = Conferences.ConferenceID and Conferences.isCanceled = 0
and ConferenceDays.StartDate > getDate()
left join ConferenceReservations
on ConferenceReservations.ConferenceDayID = ConferenceDays.ConferenceDayID
and ConferenceReservations.isCanceled = 0
and((ConferenceReservations.Paid = 1) or (DATEDIFF(day,ConferenceReservations.ReservationDate,getdate()) < 7))
group by Conferences.ConferenceID,
		 Conferences.ConferenceName,
		 ConferenceDays.ConferenceDayID,
		 ConferenceDays.StartDate, 
		 ConferenceDays.EndDate
GO
