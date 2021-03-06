USE [jsroka_a]
GO
/****** Object:  Table [dbo].[Organizers]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizers](
	[OrganizerID] [int] IDENTITY(1,1) NOT NULL,
	[OrganizatorName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Organizators] PRIMARY KEY CLUSTERED 
(
	[OrganizerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [OrganizatorEmail] CHECK  (([Email] like '%_@_%_._%'))
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [OrganizatorEmail]
GO
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [OrganizatorName] CHECK  ((ltrim([OrganizatorName])<>''))
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [OrganizatorName]
GO
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [OrganizatorPhone] CHECK  (([Phone] IS NULL OR isnumeric([Phone])=(1)))
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [OrganizatorPhone]
GO
