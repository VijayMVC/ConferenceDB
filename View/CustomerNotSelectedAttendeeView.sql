USE [jsroka_a]
GO
/****** Object:  View [dbo].[CustomerNotSelectedAttendee]    Script Date: 2018-02-04 12:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[CustomerNotSelectedAttendee] as
SELECT Customer.CustomerID, ConferenceReservationID as 'Conference/Workshop Reservation ID','Conference' as type,Quantity- (SELECT count(AttendeeID)
                                                               FROM ConferencePrincipants
                                                               WHERE ConferenceReservations.ConferenceReservationID =
                                                                     ConferencePrincipants.ConferenceReservationID
) as 'Available'
FROM Customer
INNER JOIN ConferenceReservations
  ON Customer.CustomerID = ConferenceReservations.CustomerID
WHERE Paid=1
UNION
SELECT Customer.CustomerID, WorkshopReservationID as 'Conference/Workshop Reservation ID','Workshop' as Type ,WorkshopReservations.Quantity- (SELECT COUNT(AttendeeID)
                                                                                   FROM WorkshopPrincipants
                                                                                   WHERE
                                                                                     WorkshopPrincipants.WorkshopReservationID
                                                                                     =
                                                                                     WorkshopReservations.WorkshopReservationID
) as 'Available'
FROM Customer
INNER JOIN ConferenceReservations
  ON Customer.CustomerID = ConferenceReservations.CustomerID
INNER JOIN WorkshopReservations
  ON ConferenceReservations.ConferenceReservationID = WorkshopReservations.ConferenceReservatioID
WHERE WorkshopReservations.Paid=1
GO
