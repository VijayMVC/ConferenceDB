USE [jsroka_a]
GO
/****** Object:  Table [dbo].[WorkshopReservations]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopReservations](
	[WorkshopReservationID] [int] IDENTITY(1,1) NOT NULL,
	[ConferenceReservatioID] [int] NOT NULL,
	[WorkshopID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[StudentsIncluded] [int] NOT NULL,
	[Paid] [bit] NOT NULL,
	[reservationDate] [smalldatetime] NOT NULL,
	[isCanceled] [bit] NOT NULL,
 CONSTRAINT [PK_WorkshopReservation] PRIMARY KEY CLUSTERED 
(
	[WorkshopReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_WorkshopConferenceReservationIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_WorkshopConferenceReservationIDFK] ON [dbo].[WorkshopReservations]
(
	[ConferenceReservatioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_WorkshopReservationWorkshopIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_WorkshopReservationWorkshopIDFK] ON [dbo].[WorkshopReservations]
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkshopReservations] ADD  CONSTRAINT [DF_WorkshopReservation_Paid]  DEFAULT ((0)) FOR [Paid]
GO
ALTER TABLE [dbo].[WorkshopReservations] ADD  CONSTRAINT [DF_WorkshopReservations_reservationDate]  DEFAULT (getdate()) FOR [reservationDate]
GO
ALTER TABLE [dbo].[WorkshopReservations] ADD  DEFAULT ((0)) FOR [isCanceled]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkshopReservation_ConferenceReservations] FOREIGN KEY([ConferenceReservatioID])
REFERENCES [dbo].[ConferenceReservations] ([ConferenceReservationID])
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [FK_WorkshopReservation_ConferenceReservations]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkshopReservation_Workshops] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshops] ([WorkshopID])
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [FK_WorkshopReservation_Workshops]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [PaidAndCanceledWorkshop] CHECK  ((([Paid]&[isCanceled])=(0)))
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [PaidAndCanceledWorkshop]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [reservationDate] CHECK  (([ReservationDate]<dateadd(hour,(1),getdate()) AND [ReservationDate]>dateadd(hour,(-1),getdate())))
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [reservationDate]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [Students] CHECK  (([StudentsIncluded]<=[Quantity] AND [StudentsIncluded]>=(0)))
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [Students]
GO
ALTER TABLE [dbo].[WorkshopReservations]  WITH NOCHECK ADD  CONSTRAINT [WorkshopNotNegativeQuantity] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[WorkshopReservations] NOCHECK CONSTRAINT [WorkshopNotNegativeQuantity]
GO
/****** Object:  Trigger [dbo].[CheckWorkshopOccupancy]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckWorkshopOccupancy]
  ON [dbo].[WorkshopReservations]
FOR INSERT, UPDATE

AS
  IF exists(SELECT *
FROM Workshops
WHERE dbo.getFreeSeatsQuantityAtWorkshop(WorkshopID)<0)
      BEGIN
        RAISERROR ('There is no available seats at this workshop',16,1)
        ROLLBACK TRANSACTION
        RETURN
      END
GO
ALTER TABLE [dbo].[WorkshopReservations] ENABLE TRIGGER [CheckWorkshopOccupancy]
GO
