USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[AddWorkshopRegistration]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddWorkshopRegistration](
  @WorkshopReservationID int,
  @AttendeeID int
) AS
 BEGIN
     SET NOCOUNT ON;
            DECLARE @id INT
            IF @WorkshopReservationID IS NULL
              THROW 51000,'@WorkshopReservationID is null',1
            SET @id=(SELECT WorkshopID FROM WorkshopReservations WHERE @WorkshopReservationID=WorkshopReservationID)
            if @id is NULL
              THROW 51000,'Workshop reservation with given id do not exist',1
            IF @AttendeeID is NULL
              THROW 51000,'@AttendeeID is null',1
            SET @id=(SELECT AttendeeID FROM Attendee WHERE @AttendeeID=AttendeeID)
            IF @id is NULL
              THROW 51000,'Attendee with give id do not exist',1

            INSERT INTO WorkshopPrincipants
              VALUES (@WorkshopReservationID,@AttendeeID)
 END
GO
