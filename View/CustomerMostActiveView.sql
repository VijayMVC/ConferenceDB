USE [jsroka_a]
GO
/****** Object:  View [dbo].[CustomerMostActive]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[CustomerMostActive] as 
Select CustomerName,
	   count(ConferenceReservations.Quantity) as 'ConferenceReservationCount',
	   sum(ConferenceReservations.Quantity) as 'SumOfPayedConferenceReservations' 
from Customer
inner join ConferenceReservations 
on ConferenceReservations.CustomerID = Customer.CustomerID
and ConferenceReservations.Paid = 1
group by CustomerName
GO
