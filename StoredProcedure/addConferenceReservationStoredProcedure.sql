USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addConferenceReservation]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[addConferenceReservation](
  @CustomerID INT,
  @ConferenceDayID INT,
  @Quantity INT,
  @StudentIncluded INT,
  @Paid BIT
) AS
 BEGIN
     SET NOCOUNT ON;
          IF @CustomerID is NULL
             THROW 51000,'@CustomerID is null',1;
          DECLARE @id INT
          SET @id=(SELECT CustomerID FROM Customer WHERE @CustomerID=CustomerID)
          IF @id is NULL
              THROW 51000,'@Customer with given id do not exist',1
          IF @ConferenceDayID is NULL
              THROW 51000,'@ConferenceDayID is null',1
          DECLARE @confDayID INT
          SET @confDayID=(SELECT ConferenceDayID FROM ConferenceDays WHERE ConferenceDayID=@ConferenceDayID)
          IF @confDayID is NULL
            THROW 51000,'@Conference day with given id do not exist',1
          IF @Quantity is NULL or @Quantity<=0
            THROW  51000,'@Quantity is null or Quantity is < 0',1
          IF @Quantity>dbo.getFreeSeatsQuantityAtConferenceDay (@confDayID)
            THROW 51000,'@Quantity is too much',1
          IF @StudentIncluded is null or @StudentIncluded>@Quantity
            THROW 51000,'@StudentIncluded is null or @StudentIncluded is greater that @Quantity',1
          IF @Paid IS NULL
            THROW 51000,'@Paid is null',1


         INSERT INTO ConferenceReservations
           VALUES (@CustomerID,@ConferenceDayID,@Quantity,@StudentIncluded,@Paid,getdate(),0)
 END
GO
