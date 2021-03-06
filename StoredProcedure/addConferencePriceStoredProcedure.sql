USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[addConferencePrice]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[addConferencePrice](
	@StudentDiscount		float,
	@DaysToConference		int,
	@Price					smallmoney,
	@ConferenceDayID		int
) AS BEGIN
  SET NOCOUNT ON;  
		IF @ConferenceDayID is null 
			THROW 51000, '@ConferenceDayID is null ', 1
		Declare @date smalldatetime
		Select @date =  (Select ConferenceDays.StartDate from ConferenceDays where ConferenceDays.ConferenceDayID = @ConferenceDayID)
		IF @date is null 
			THROW 51000, 'ConferenceDay with given Id does not exist ', 1
		IF @DaysToConference is  null or  @DaysToConference < 0
			THROW 51000, '@DaysToConference is null or negative ', 1
		IF @Price is  null or  @Price < 0
			THROW 51000, '@Price is null or negative ', 1
		IF @StudentDiscount is  null or  @StudentDiscount < 0 or @StudentDiscount > 1
			THROW 51000, '@StudentDiscount is null or not between 0 and 1 ', 1
		
		INSERT INTO Prices(StudentDiscount, DaysToConference, Price, ConferenceDayID)
		VALUES (@StudentDiscount, @DaysToConference, @Price, @ConferenceDayID)
END  
GO
