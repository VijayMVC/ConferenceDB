USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[modifyConferenceDay]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[modifyConferenceDay](
  @ConferenceDayID INT,
	@ConferenceID			int,
	@StartDate    smalldatetime,
	@EndDate	  smalldatetime,
	@Seats					int
) AS BEGIN
  SET NOCOUNT ON;
    IF @ConferenceID is NULL 
      THROW 51000,'@ConferenceID is null',1
    DECLARE @idConfDay INT
    SET @idConfDay=(SELECT ConferenceDayID FROM ConferenceDays WHERE ConferenceDayID=@ConferenceDayID)
    IF @idConfDay IS NULL
      THROW 51000,'Conference day with given id do not exist',1
		IF @ConferenceID is null
			THROW 51000, '@ConferenceID is null ', 1
		Declare @id int
		Select @id =  (Select Conferences.ConferenceID from Conferences where ConferenceID = @ConferenceID)
		IF @id is null
			THROW 51000, 'Conference with given Id does not exist ', 1
		IF @StartDate is  null or  @StartDate < getDate()
			THROW 51000, '@StartDate is null or is date in past ', 1
		IF @EndDate is  null or  @EndDate < getDate() or @EndDate <= @StartDate
			THROW 51000, '@EndDate is null or is date in past or or is lower than StartDate', 1
		IF @Seats is  null or  @Seats <= 0
			THROW 51000, '@Seats is null or not positive ', 1

		UPDATE ConferenceDays
      SET ConferenceID=@ConferenceID,
        StartDate=@StartDate,
        EndDate=@EndDate,
        Seats=@Seats
    WHERE ConferenceDayID=@ConferenceDayID
END
GO
