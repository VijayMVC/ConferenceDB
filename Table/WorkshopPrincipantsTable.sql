USE [jsroka_a]
GO
/****** Object:  Table [dbo].[WorkshopPrincipants]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkshopPrincipants](
	[WorkshopPrincipantID] [int] IDENTITY(1,1) NOT NULL,
	[WorkshopReservationID] [int] NOT NULL,
	[AttendeeID] [int] NOT NULL,
 CONSTRAINT [PK_WorkshopPrincipants] PRIMARY KEY CLUSTERED 
(
	[WorkshopPrincipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_WorkshopAttendeeIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_WorkshopAttendeeIDFK] ON [dbo].[WorkshopPrincipants]
(
	[AttendeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_WorkshopReservationIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_WorkshopReservationIDFK] ON [dbo].[WorkshopPrincipants]
(
	[WorkshopReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkshopPrincipants]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkshopPrincipants_Atendee] FOREIGN KEY([AttendeeID])
REFERENCES [dbo].[Attendee] ([AttendeeID])
GO
ALTER TABLE [dbo].[WorkshopPrincipants] NOCHECK CONSTRAINT [FK_WorkshopPrincipants_Atendee]
GO
ALTER TABLE [dbo].[WorkshopPrincipants]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkshopPrincipants_WorkshopReservation] FOREIGN KEY([WorkshopReservationID])
REFERENCES [dbo].[WorkshopReservations] ([WorkshopReservationID])
GO
ALTER TABLE [dbo].[WorkshopPrincipants] NOCHECK CONSTRAINT [FK_WorkshopPrincipants_WorkshopReservation]
GO
/****** Object:  Trigger [dbo].[CheckWorkshopRegistrationAttendeeDuplicate]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[CheckWorkshopRegistrationAttendeeDuplicate]
  ON [dbo].[WorkshopPrincipants]
FOR INSERT, UPDATE
AS IF exists(
    SELECT WorkshopReservations.WorkshopReservationID, WorkshopPrincipants.AttendeeID ,count(WorkshopPrincipants.AttendeeID)
    FROM WorkshopReservations
	inner join WorkshopPrincipants
	on WorkshopPrincipants.WorkshopReservationID = WorkshopReservations.WorkshopReservationID
	group by 
	WorkshopReservations.WorkshopReservationID,
	WorkshopPrincipants.AttendeeID
	having count(WorkshopPrincipants.AttendeeID) > 1
	)
     BEGIN
       RAISERROR ('Duplicate of AttendeeID',16,1)
       ROLLBACK TRANSACTION
       RETURN
     END
GO
ALTER TABLE [dbo].[WorkshopPrincipants] ENABLE TRIGGER [CheckWorkshopRegistrationAttendeeDuplicate]
GO
/****** Object:  Trigger [dbo].[CheckWorkshopRegistrationCustomerPayment]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckWorkshopRegistrationCustomerPayment] ON [dbo].[WorkshopPrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select WorkshopReservations.Paid
			from WorkshopReservations
			inner join WorkshopPrincipants
			on WorkshopPrincipants.WorkshopReservationID = WorkshopReservations.WorkshopReservationID
			where WorkshopReservations.Paid = 0)
BEGIN  
RAISERROR ('Participant were signed to unpaid reservation', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[WorkshopPrincipants] ENABLE TRIGGER [CheckWorkshopRegistrationCustomerPayment]
GO
/****** Object:  Trigger [dbo].[CheckWorkshopRegistrationQuantity]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckWorkshopRegistrationQuantity]
  ON [dbo].[WorkshopPrincipants]
FOR INSERT, UPDATE
AS
  IF exists(
      SELECT
        WorkshopReservationID,
        count(WorkshopPrincipantID) AS qt
      FROM WorkshopPrincipants
      GROUP BY WorkshopReservationID
      HAVING count(WorkshopPrincipantID) > (SELECT Quantity
                                            FROM WorkshopReservations
                                            WHERE WorkshopPrincipants.WorkshopReservationID =
                                                  WorkshopReservations.WorkshopReservationID)
  )
      BEGIN
        RAISERROR ('You cannot insert more attendee than reserved',16,1)
        ROLLBACK TRANSACTION
        RETURN 
      END
GO
ALTER TABLE [dbo].[WorkshopPrincipants] ENABLE TRIGGER [CheckWorkshopRegistrationQuantity]
GO
/****** Object:  Trigger [dbo].[CheckWorkshopRegistrationStudentsQuantity]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[CheckWorkshopRegistrationStudentsQuantity] ON [dbo].[WorkshopPrincipants]  
AFTER INSERT, UPDATE  
AS  
IF Exists (Select WorkshopReservations.WorkshopReservationID,
					WorkshopReservations.Quantity  - WorkshopReservations.StudentsIncluded ,
					count(WorkshopPrincipants.WorkshopPrincipantID)
			from WorkshopReservations
			inner join WorkshopPrincipants
			on WorkshopPrincipants.WorkshopReservationID = WorkshopReservations.WorkshopReservationID
			inner join Attendee 
			on Attendee.AttendeeID = WorkshopPrincipants.AttendeeID
			and Attendee.StudentIDCardNumber is null
			group by WorkshopReservations.WorkshopReservationID,
					WorkshopReservations.Quantity,
					WorkshopReservations.StudentsIncluded
					having  (WorkshopReservations.Quantity  - WorkshopReservations.StudentsIncluded )< count(WorkshopPrincipants.WorkshopPrincipantID) )
BEGIN  
RAISERROR ('There are too much participants without StudentIDCardNumber but there is still
available room for students participants', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[WorkshopPrincipants] ENABLE TRIGGER [CheckWorkshopRegistrationStudentsQuantity]
GO
