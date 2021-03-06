USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addWorkshop]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[addWorkshop](
	@ConferenceDayID	int,
	@WorkshopName	nvarchar(50),
	@Seats	int,
	@StartTime	time(7),
	@EndTime	time(7),
	@Price	smallmoney
) AS BEGIN
  SET NOCOUNT ON;  
		IF @ConferenceDayID is null 
			THROW 51000, '@ConferenceDayID is null', 1
		Declare @date smalldatetime
		Select @date =  (Select ConferenceDays.StartDate from ConferenceDays where ConferenceDayID = @ConferenceDayID)
		IF @date is null 
			THROW 51000, '@ConferenceDay with given Id does not exist ', 1
		IF @WorkshopName is not  null and ltrim(@WorkshopName) = ''
			THROW 51000, '@WorkshopName is empty String ', 1		
		IF @Seats is null or @Seats <= 0 
			THROW 51000, '@Seats is null or is not positive value', 1
		IF @StartTime is null
			THROW 51000, '@StartTime is null', 1
		IF @EndTime is null
			THROW 51000, '@EndTime is null', 1
		IF @EndTime < @StartTime
			THROW 51000, '@StartTime is greater than @Endtime ', 1
		IF @Price is null or @Price < 0 
			THROW 51000, '@Price is null or is negative value', 1
		
		INSERT INTO Workshops(ConferenceDayID, WorkshopName, Seats, StartTime, EndTime, Price)
		VALUES (@ConferenceDayID, @WorkshopName, @Seats, @StartTime, @EndTime, @Price)
END  
GO
