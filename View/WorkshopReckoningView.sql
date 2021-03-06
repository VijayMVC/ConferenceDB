USE [jsroka_a]
GO
/****** Object:  View [dbo].[WorkshopReckoning]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WorkshopReckoning] AS 
SELECT ConferenceDayID,sum(Price*Quantity) as total
FROM Workshops
INNER JOIN WorkshopReservations
  ON Workshops.WorkshopID = WorkshopReservations.WorkshopID
WHERE WorkshopReservations.Paid=1 and Workshops.isCanceled=0
GROUP BY ConferenceDayID
GO
