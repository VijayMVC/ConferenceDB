USE [jsroka_a]
GO
/****** Object:  Table [dbo].[Prices]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prices](
	[PriceID] [int] IDENTITY(1,1) NOT NULL,
	[StudentDiscount] [float] NOT NULL,
	[DaysToConference] [int] NOT NULL,
	[Price] [smallmoney] NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
 CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED 
(
	[PriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_ConferencePriceFK]    Script Date: 2018-02-04 12:36:19 ******/
CREATE NONCLUSTERED INDEX [idx_ConferencePriceFK] ON [dbo].[Prices]
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Prices]  WITH NOCHECK ADD  CONSTRAINT [FK_Prices_ConferenceDays] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[ConferenceDays] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[Prices] NOCHECK CONSTRAINT [FK_Prices_ConferenceDays]
GO
ALTER TABLE [dbo].[Prices]  WITH NOCHECK ADD  CONSTRAINT [DaysToConferenceNotNegative] CHECK  (([DaysToConference]>=(0)))
GO
ALTER TABLE [dbo].[Prices] NOCHECK CONSTRAINT [DaysToConferenceNotNegative]
GO
ALTER TABLE [dbo].[Prices]  WITH NOCHECK ADD  CONSTRAINT [Discount] CHECK  (([StudentDiscount]>=(0) AND [StudentDiscount]<=(1)))
GO
ALTER TABLE [dbo].[Prices] NOCHECK CONSTRAINT [Discount]
GO
ALTER TABLE [dbo].[Prices]  WITH NOCHECK ADD  CONSTRAINT [NotNegativePrice] CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[Prices] NOCHECK CONSTRAINT [NotNegativePrice]
GO
/****** Object:  Trigger [dbo].[CheckPriceDaysToConferenceDuplicate]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckPriceDaysToConferenceDuplicate] ON [dbo].[Prices]   
AFTER INSERT, UPDATE  
AS  
IF Exists (Select * from Prices
			group by Prices.ConferenceDayID,
					Prices.DaysToConference
			having count(Prices.Price) > 1)
BEGIN  
RAISERROR ('Price for conference has duplicate according to "daysToConference" on same conference Day ', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[Prices] ENABLE TRIGGER [CheckPriceDaysToConferenceDuplicate]
GO
/****** Object:  Trigger [dbo].[CheckPricesMonotonicity]    Script Date: 2018-02-04 12:36:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CheckPricesMonotonicity] ON [dbo].[Prices]   
AFTER INSERT, UPDATE  
AS  
IF Exists (Select * from Prices as p1
			cross join Prices as p2
			where p1.ConferenceDayID = p2.ConferenceDayID 
			and p1.DaysToConference < p2.DaysToConference
			and p1.Price < p2.Price  )
BEGIN  
RAISERROR ('Price for conference is not monotonic according to daystoconference ', 16, 1);  
ROLLBACK TRANSACTION;  
RETURN   
END;  
GO
ALTER TABLE [dbo].[Prices] ENABLE TRIGGER [CheckPricesMonotonicity]
GO
