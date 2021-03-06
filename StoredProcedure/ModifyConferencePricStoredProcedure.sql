USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[ModifyConferencePrice]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[ModifyConferencePrice](
	@PriceID int,
  @StudentDiscount float,
  @DaysToConference int,
  @Price FLOAT
) AS BEGIN
  SET NOCOUNT ON;
  IF @PriceID is null
			THROW 51000, '@PriceID is null', 1

  DECLARE @id int
  SELECT @id=PriceID FROM Prices WHERE @PriceID=PriceID
  IF @id IS NULL
    THROW 51000,'Price with given id do not exist',1

  if @StudentDiscount is NULL
    THROW 51000, '@StudentDiscount is null', 1

  IF @DaysToConference IS NULL
    THROW 51000, '@DaysToConference is null', 1

  IF @Price IS NULL
    THROW 51000, '@Price is null', 1

  IF @StudentDiscount>=1 OR @StudentDiscount<0
    THROW 51000,'@StudentDiscount must be in range <0,1)',1

  If @DaysToConference<0
    THROW 51000,'@DaysToConference must be greater than zero)',1

  If @Price<0
    THROW 51000,'@Price must be greater than zero)',1

  IF exists(SELECT TOP (1)
              PriceID,
              min(Price) AS priceMin
            FROM Prices
              INNER JOIN ConferenceDays
                ON Prices.ConferenceDayID = ConferenceDays.ConferenceDayID
              INNER JOIN ConferenceReservations
                ON ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
            WHERE Paid = 1 AND DaysToConference < datediff(DAY, ReservationDate, StartDate)
            GROUP BY PriceID
            ORDER BY priceMin
  )
    THROW 51000,'Client paid for conference using this price, you cannot change it',1


  DECLARE @date SMALLDATETIME
  SELECT @date=ConferenceDays.StartDate
  FROM Prices
  INNER JOIN ConferenceDays
    ON Prices.ConferenceDayID = ConferenceDays.ConferenceDayID
  WHERE @PriceID=PriceID
  IF @date>=getdate()
    THROW 51000,'Conference has already started',1

END
GO
