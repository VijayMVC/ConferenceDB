USE [jsroka_a]
GO
/****** Object:  UserDefinedFunction [dbo].[totalPriceForReservation]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[totalPriceForReservation](@ConferenceReservationID int)
  RETURNS int
  BEGIN
    DECLARE @ret int
    SELECT @ret=(Quantity*Price)-(StudentsIncluded*StudentDiscount*Price)
    FROM Prices
    INNER JOIN ConferenceDays
      ON Prices.ConferenceDayID = ConferenceDays.ConferenceDayID
    INNER JOIN ConferenceReservations
      ON ConferenceDays.ConferenceDayID = ConferenceReservations.ConferenceDayID
    WHERE @ConferenceReservationID=ConferenceReservationID and Price=(SELECT min(Price)
FROM Prices as pr
INNER JOIN ConferenceDays as confDay
  ON pr.ConferenceDayID = confDay.ConferenceDayID
INNER JOIN ConferenceReservations confReservation
  ON confDay.ConferenceDayID = confReservation.ConferenceDayID and confReservation.ConferenceDayID=ConferenceReservations.ConferenceDayID
WHERE DaysToConference<= DATEDIFF(DAY,confReservation.ReservationDate,confDay.StartDate)
    )
    RETURN @ret
  END
GO
