USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[modifyConference]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[modifyConference](
  @ConferenceID int,
  @isCanceled bit,
	@ConferenceName	nvarchar(50),
	@OrganizerID	int
) AS BEGIN
  SET NOCOUNT ON;
		Declare @name nvarchar(50)
		Select @name =  (Select Organizers.OrganizatorName from Organizers where OrganizerID = @OrganizerID)
		IF @name is null and @OrganizerId is not null
			THROW 51000, 'Organizer with given Id does not exist ', 1
		IF @ConferenceName is not null and ltrim(@ConferenceName) = ''
			THROW 51000, '@ConferenceName is empty String ', 1
    IF @ConferenceID is NULL 
      THROW 51000,'@ConferenceID is null',1
    DECLARE @id INT
    SET @id=(SELECT ConferenceID FROM Conferences WHERE ConferenceID=@ConferenceID)
    IF @id is NULL 
      THROW 51000,'Conference with given id do not exist',1
    IF @isCanceled is NULL 
      THROW 51000,'@isCanceled is null',1
    
		UPDATE Conferences
      SET isCanceled=@isCanceled,
        ConferenceName=@ConferenceName,
        OrganizerID=@OrganizerID
    WHERE ConferenceID=@ConferenceID
END
GO
