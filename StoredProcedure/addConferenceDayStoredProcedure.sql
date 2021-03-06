USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addConferenceDay]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[addConferenceDay](
	@ConferenceID			int,
	@StartDate    smalldatetime,
	@EndDate	  smalldatetime,
	@Seats					int
) AS BEGIN
  SET NOCOUNT ON;  
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
		
		INSERT INTO ConferenceDays(ConferenceID, StartDate, EndDate, Seats)
		VALUES (@ConferenceID, @StartDate, @EndDate, @Seats)
END  
GO
