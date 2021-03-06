USE [jsroka_a]
GO
/****** Object:  View [dbo].[ConferenceCanceledRepayment]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ConferenceCanceledRepayment] as
SELECT DISTINCT Customer.CustomerID,CustomerName,ConferenceReservationID, dbo.totalPriceForReservation(ConferenceReservationID) as Refund
FROM Customer
INNER JOIN ConferenceReservations
  ON Customer.CustomerID = ConferenceReservations.CustomerID
INNER JOIN ConferenceDays
  ON ConferenceReservations.ConferenceDayID = ConferenceDays.ConferenceDayID
INNER JOIN Conferences
  ON ConferenceDays.ConferenceID = Conferences.ConferenceID
INNER JOIN Prices
  ON ConferenceDays.ConferenceDayID = Prices.ConferenceDayID
WHERE Conferences.isCanceled=1 and Paid=1
GO
