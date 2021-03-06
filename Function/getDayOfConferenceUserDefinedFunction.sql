USE [jsroka_a]
GO
/****** Object:  UserDefinedFunction [dbo].[getDayOfConference]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getDayOfConference](@ConferenceDayID int)
  RETURNS INT
  BEGIN
    DECLARE @ret INT
    DECLARE @conferenceID INT
    DECLARE @date SMALLDATETIME
    SELECT @conferenceID=ConferenceID, @date=StartDate
    FROM ConferenceDays WHERE @ConferenceDayID=ConferenceDayID;


    SELECT @ret=count(ConferenceDayID)
    FROM ConferenceDays
    WHERE ConferenceID=@conferenceID and EndDate<@date

    RETURN @ret+1
  END
GO
