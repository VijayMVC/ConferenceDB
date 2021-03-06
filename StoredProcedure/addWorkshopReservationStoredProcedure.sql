USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addWorkshopReservation]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[addWorkshopReservation](
  @ConferenceReservationID int,
  @WorkshopID int,
  @Quantity int,
  @StudentIncluded int,
  @Paid BIT
) AS
 BEGIN
     SET NOCOUNT ON;
          IF @ConferenceReservationID is NULL
            THROW 51000,'@ConferenceReservationID is null',1
          DECLARE @id int
          SET @id=(SELECT ConferenceReservationID FROM ConferenceReservations WHERE ConferenceReservationID=@ConferenceReservationID)
          IF @id is NULL
            THROW 51000,'Conferece reservation with given id do not exist',1
          IF @WorkshopID is NULL 
            THROW 51000,'@WorkshopID is null',1
          SET @id=(SELECT WorkshopID FROM Workshops WHERE @WorkshopID=WorkshopID)
          IF @id IS NULL 
            THROW 51000,'Workshop with given id do not exist',1
          IF @Quantity is NULL or @Quantity<=0
            THROW 51000,'@Quantity is null or @Quantity < 0',1
          IF @Quantity>dbo.getFreeSeatsQuantityAtWorkshop (@WorkshopID)
            THROW 51000,'@Quantity is greater than free setas',1
          IF @StudentIncluded is NULL or @StudentIncluded<0 or @StudentIncluded>@Quantity
            THROW 51000,'@StudentIncluded is null or @StudentInclude<0 or @StudentInclude>@Quantuty',1
          IF @Paid is NULL 
            THROW 51000,'@Paid is null',1

          INSERT INTO WorkshopReservations
            VALUES (@ConferenceReservationID,@WorkshopID,@Quantity,@StudentIncluded,@Paid,getdate(),0)


 END
GO
