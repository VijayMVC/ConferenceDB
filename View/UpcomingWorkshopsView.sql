USE [jsroka_a]
GO
/****** Object:  View [dbo].[UpcomingWorkshops]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create View [dbo].[UpcomingWorkshops] as 
select  Conferences.ConferenceID,
		ConferenceDays.ConferenceDayID,
		Workshops.WorkshopID,
		WorkshopName,
		cast(ConferenceDays.StartDate as date) as 'Date', 
		cast (Workshops.StartTime as time(0)) as 'StartTime',
		cast (Workshops.EndTime as time(0)) as 'EndTime',
		min(Workshops.Seats) - ISNULL(sum(WorkshopReservations.Quantity) , 0) as 'AvailableSeats'
from Conferences
inner join ConferenceDays 
on ConferenceDays.ConferenceID = Conferences.ConferenceID
and ConferenceDays.StartDate > getDate()
inner join Workshops 
on Workshops.ConferenceDayID = ConferenceDays.ConferenceDayID and Workshops.isCanceled = 0
left join WorkshopReservations 
on WorkshopReservations.WorkshopID = Workshops.WorkshopID
and WorkshopReservations.isCanceled = 0 
and((WorkshopReservations.Paid = 1)  or (datediff(day ,WorkshopReservations.reservationDate,getdate()) < 7))
group by Conferences.ConferenceID,
		 ConferenceDays.ConferenceDayID,
		 ConferenceDays.StartDate, 
		 Workshops.WorkshopID,
		 WorkshopName,
		 Workshops.StartTime,
		 Workshops.EndTime
GO
