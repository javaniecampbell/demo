-- =============================================
-- Create database template
-- =============================================
-- USE master
-- GO

-- Drop the database if it already exists
-- IF  EXISTS (
-- 	SELECT name 
-- 		FROM sys.databases 
-- 		WHERE name = N'historyStreamStore'
-- )
-- DROP DATABASE [historyStreamStore]
-- GO

CREATE DATABASE [historyStreamStore];
GO

USE [historyStreamStore];
GO

-- =========================================
-- Create table Aggregates
-- =========================================
USE [historyStreamStore];
GO

IF OBJECT_ID('[dbo].[Events]', 'U') IS NOT NULL
  DROP TABLE[dbo].[Events]
GO

IF OBJECT_ID('[dbo].[Aggregates]', 'U') IS NOT NULL
  DROP TABLE[dbo].[Aggregates]
GO

CREATE TABLE [dbo].[Aggregates]
(
	[AggregateId] UNIQUEIDENTIFIER NOT NULL, 
	[Type] VARCHAR(255) NOT NULL, 
	[Version] BIGINT NULL, 
    CONSTRAINT pk_Aggregate PRIMARY KEY (AggregateId)
)
GO
-- =========================================
-- Create table Events
-- =========================================
USE [historyStreamStore];
GO

IF OBJECT_ID('[dbo].[Events]', 'U') IS NOT NULL
  DROP TABLE[dbo].[Events]
GO

CREATE TABLE [dbo].[Events]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[Created] DATETIME NOT NULL,
	[AggregateType] NVARCHAR(255) NOT NULL,
	[AggregateId] UNIQUEIDENTIFIER NOT NULL, 
	[Version] BIGINT NOT NULL, 
	[Event] NVARCHAR(MAX) NOT NULL, 
	[MetaData] NVARCHAR(MAX) NOT NULL,
	[Dispatched] BIT NOT NULL DEFAULT(0),
	[SequenceTimeStamp] DATETIME NOT NULL DEFAULT (CURRENT_TIMESTAMP), --This is used for events received out of order via asynchronous call
    CONSTRAINT pk_Events PRIMARY KEY (Id) --This creates a 1-to-1 relationship.
)
GO

ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Events_dbo.Aggregates_AggregateId] FOREIGN KEY([AggregateId])
REFERENCES [dbo].[Aggregates] ([AggregateId])
GO
-- =========================================
-- Create table Snapshots
-- =========================================
USE [historyStreamStore];
GO

IF OBJECT_ID('[dbo].[Snapshots]', 'U') IS NOT NULL
  DROP TABLE[dbo].[Snapshots]
GO

CREATE TABLE [dbo].[Snapshots]
(
	 AggregateId UNIQUEIDENTIFIER NOT NULL,
	 Version BIGINT NULL,    
	 [TimeStamp] DATETIME NOT NULL,    
	 Type NVARCHAR(255) NOT NULL,    
	 Data NVARCHAR(MAX) NOT NULL

    CONSTRAINT pk_EventSnapshots PRIMARY KEY (AggregateId) --This creates a 1-to-1 relationship.
)
GO

