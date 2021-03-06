USE [jsroka_a]
GO
/****** Object:  UserDefinedFunction [dbo].[getFreeSeatsQuantityAtConferenceDay]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getFreeSeatsQuantityAtConferenceDay](@ConferenceDayID int)
 RETURNS int
 BEGIN
   DECLARE @ret int
   DECLARE @isCancelled int
   SELECT @isCancelled=Conferences.isCanceled
   FROM ConferenceDays
   INNER JOIN Conferences
     ON ConferenceDays.ConferenceID = Conferences.ConferenceID
   WHERE @ConferenceDayID=ConferenceDays.ConferenceDayID

   IF @isCancelled=1
     BEGIN
       RETURN NULL
     END
   ELSE
     BEGIN

   SELECT @ret=ConferenceDays.Seats- (SELECT sum(Quantity)
                       FROM ConferenceReservations
                       WHERE datediff(DAY, getdate(), ConferenceReservations.ReservationDate) BETWEEN 0 AND 7 AND
                             ConferenceReservations.isCanceled = 0 and ConferenceReservations.ConferenceDayID=ConferenceDays.ConferenceDayID
   )
   FROM ConferenceDays
   WHERE ConferenceDays.ConferenceDayID=@ConferenceDayID
     END
   RETURN @ret
 END
GO
