USE [jsroka_a]
GO
/****** Object:  StoredProcedure [dbo].[modifyCustomer]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[modifyCustomer](
  @CustomerID int,
	@CustomerName	nvarchar(50),
	@Country	nvarchar(50),
	@City	nvarchar(50),
	@Address	nvarchar(50),
	@Phone	nchar(10),
	@isCompany	bit,
	@NIP	nchar(10)
) AS BEGIN
  SET NOCOUNT ON;
    IF @CustomerID is NULL
      THROW 51000, '@CustomerID is null',1
    DECLARE @id INT
    SET @id=(SELECT CustomerID FROM Customer WHERE @CustomerID=CustomerID)
    IF @id is NULL
      THROW 51000,'Customer with given id do not exist',1
		IF @CustomerName is null or ltrim(@CustomerName) = ''
			THROW 51000, '@name is null or is empty String ', 1
		IF @CustomerName is null or ltrim(@Country) = ''
			THROW 51000, '@Country is null or is empty String ', 1
		IF @CustomerName is null or ltrim(@City) = ''
			THROW 51000, '@City is null or is empty String ', 1
		IF @CustomerName is null or ltrim(@Address) = ''
			THROW 51000, '@Address is null or is empty String ', 1
		IF @isCompany is null
			THROW 51000, '@isCompany is null ', 1
		IF @Phone is not null and ISNUMERIC(@Phone) = 0
			THROW 51000, '@Phone is String which contains not numeric values', 1
		IF @NIP is not null and ISNUMERIC(@NIP) = 0
			THROW 51000, '@NIP is String which contains not numeric values', 1
		IF @NIP is not null and LEN(@NIP) <> 10
			THROW 51000, '@NIP should have 10 digits', 1

		UPDATE Customer
      SET CustomerName=@CustomerName,
        Country=@Country,
        City=@City,
        Address=@Address,
        Phone=@Phone,
        isCompany=@isCompany,
        NIP=@NIP
    WHERE CustomerID=@CustomerID
    
END
GO
