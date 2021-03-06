USE [jsroka_a]
GO
/****** Object:  View [dbo].[Schedule]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Schedule] AS
SELECT WorkshopName, dbo.getDayOfConference(Workshops.ConferenceDayID) as 'Conference Day', convert(CHAR(8),StartTime)+' '+convert(CHAR,convert(DATE, StartDate)) as 'Start date'
FROM Workshops
INNER JOIN ConferenceDays
  ON Workshops.ConferenceDayID = ConferenceDays.ConferenceDayID
GO
