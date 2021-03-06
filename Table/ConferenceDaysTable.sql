USE [jsroka_a]
GO
/****** Object:  Table [dbo].[ConferenceDays]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConferenceDays](
	[ConferenceDayID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceID] [int] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[Seats] [int] NOT NULL,
 CONSTRAINT [PK_ConferenceDays] PRIMARY KEY CLUSTERED 
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferenceIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferenceIDFK] ON [dbo].[ConferenceDays]
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConferenceDays]  WITH NOCHECK ADD  CONSTRAINT [FK_ConferenceDays_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[ConferenceDays] NOCHECK CONSTRAINT [FK_ConferenceDays_Conferences]
GO
ALTER TABLE [dbo].[ConferenceDays]  WITH NOCHECK ADD  CONSTRAINT [Dates] CHECK  (([EndDate]>[StartDate]))
GO
ALTER TABLE [dbo].[ConferenceDays] NOCHECK CONSTRAINT [Dates]
GO
ALTER TABLE [dbo].[ConferenceDays]  WITH NOCHECK ADD  CONSTRAINT [NotNegativeQuantity] CHECK  (([Seats]>(0)))
GO
ALTER TABLE [dbo].[ConferenceDays] NOCHECK CONSTRAINT [NotNegativeQuantity]
GO
/****** Object:  Trigger [dbo].[CheckConferenceDaysConflictTime]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceDaysConflictTime]
  ON [dbo].[ConferenceDays]
FOR INSERT, UPDATE
AS IF exists(
    SELECT *
    FROM ConferenceDays
      INNER JOIN ConferenceDays AS cd
        ON cd.ConferenceID = ConferenceDays.ConferenceID AND
           cd.ConferenceDayID < ConferenceDays.ConferenceDayID
    WHERE
      convert(DATE, ConferenceDays.StartDate) = convert(DATE, cd.StartDate)

)
     BEGIN
       RAISERROR ('ConferencesDays cannot take place in the same day',16,1)
       ROLLBACK TRANSACTION
       RETURN
     END
GO
ALTER TABLE [dbo].[ConferenceDays] ENABLE TRIGGER [CheckConferenceDaysConflictTime]
GO
/****** Object:  Trigger [dbo].[CheckConferenceDaysDifferenceBetweenFirstAndLastDay]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceDaysDifferenceBetweenFirstAndLastDay]
  ON [dbo].[ConferenceDays]
FOR INSERT, UPDATE
AS IF exists(
    SELECT
      ConferenceID,
      min(StartDate),
      max(EndDate),
      datediff(DAY, min(StartDate), max(EndDate)) + 1 AS days
    FROM ConferenceDays
    GROUP BY ConferenceID
    HAVING datediff(DAY, min(StartDate), max(EndDate)) + 1 > 4
)
     BEGIN
       RAISERROR ('Max duration of conference is 4 days',16,1)
       ROLLBACK TRANSACTION
       RETURN
     END
GO
ALTER TABLE [dbo].[ConferenceDays] ENABLE TRIGGER [CheckConferenceDaysDifferenceBetweenFirstAndLastDay]
GO
/****** Object:  Trigger [dbo].[CheckConferenceDaysDurationTime]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckConferenceDaysDurationTime]
  ON [dbo].[ConferenceDays]
FOR INSERT, UPDATE
AS IF exists(
    SELECT *
    FROM ConferenceDays
    WHERE convert(DATE, StartDate) != convert(DATE, EndDate)
)
     BEGIN
       RAISERROR ('Conference day must start and end in the same day',16,1)
       ROLLBACK TRANSACTION
       RETURN
     END
GO
ALTER TABLE [dbo].[ConferenceDays] ENABLE TRIGGER [CheckConferenceDaysDurationTime]
GO
