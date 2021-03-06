USE [jsroka_a]
GO
/****** Object:  Table [dbo].[Attendee]    Script Date: 2018-02-04 12:36:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendee](
	[AttendeeID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[StudentIDCardNumber] [int] NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Atendee] PRIMARY KEY CLUSTERED 
(
	[AttendeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Email_Atendee] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_CustomerIDFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_CustomerIDFK] ON [dbo].[Attendee]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attendee]  WITH NOCHECK ADD  CONSTRAINT [FK_Atendee_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Attendee] NOCHECK CONSTRAINT [FK_Atendee_Customer]
GO
ALTER TABLE [dbo].[Attendee]  WITH NOCHECK ADD  CONSTRAINT [EmailAdd] CHECK  (([Email] IS NULL OR [Email] like '%_@_%_._%'))
GO
ALTER TABLE [dbo].[Attendee] NOCHECK CONSTRAINT [EmailAdd]
GO
ALTER TABLE [dbo].[Attendee]  WITH NOCHECK ADD  CONSTRAINT [EmptyFirstName] CHECK  ((ltrim([FirstName])<>''))
GO
ALTER TABLE [dbo].[Attendee] NOCHECK CONSTRAINT [EmptyFirstName]
GO
ALTER TABLE [dbo].[Attendee]  WITH NOCHECK ADD  CONSTRAINT [EmptyLastName] CHECK  ((ltrim([LastName])<>''))
GO
ALTER TABLE [dbo].[Attendee] NOCHECK CONSTRAINT [EmptyLastName]
GO
ALTER TABLE [dbo].[Attendee]  WITH NOCHECK ADD  CONSTRAINT [EmptyPassword] CHECK  ((ltrim([Password])<>''))
GO
ALTER TABLE [dbo].[Attendee] NOCHECK CONSTRAINT [EmptyPassword]
GO
