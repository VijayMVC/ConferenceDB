USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[modifyOrganizer]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[modifyOrganizer](
	@OrganizerID int,
	@OrganizatorName nvarchar(20),
	@Email nvarchar(50),
	@Phone nvarchar(20) 
) AS BEGIN
  SET NOCOUNT ON;  
		IF @OrganizerID is null 
			THROW 51000, '@AttendeeID is null', 1
		
		Declare @id int
		Select @id =  (Select OrganizerID from Organizers where OrganizerID = @OrganizerID)
		IF @id is null 
			THROW 51000, 'OrganizerID with given Id does not exist ', 1

		IF @OrganizatorName is null or ltrim(@OrganizatorName) = ''
			THROW 51000, '@OrganizatorName is null or is empty String ', 1		
		IF @Phone is null or ltrim(@Phone) = '' or ISNUMERIC(@Phone) = 0
			THROW 51000, '@LastName is null or is empty String or is not proper phone number ', 1
		IF @Email is not null and ltrim(@Email) = ''
			THROW 51000, '@Email is empty String ', 1

		Update Organizers
		set OrganizatorName = @OrganizatorName,
	    Email = @Email,
		Phone = @Phone
		where OrganizerID = @OrganizerID;
END  
GO
