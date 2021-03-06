USE [jsroka_a]
GO
/****** Object:  View [dbo].[ConferenceReckoning]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ConferenceReckoning] as
SELECT Conferences.ConferenceID,ConferenceName,ConferenceDays.ConferenceDayID, sum(dbo.totalPriceForReservation(ConferenceReservationID)) as totalPrice
FROM Conferences
INNER JOIN ConferenceDays
  ON Conferences.ConferenceID = ConferenceDays.ConferenceID
INNER JOIN ConferenceReservations
  ON ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
    WHERE ConferenceReservations.Paid=1 and Conferences.isCanceled=0
GROUP BY Conferences.ConferenceID,ConferenceName, ConferenceDays.ConferenceDayID
GO
