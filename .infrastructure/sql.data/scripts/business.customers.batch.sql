CREATE DATABASE [business-customers];
GO
USE [business-customers];
GO
-- Generated Script modify below --
-----------------------------------
IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

CREATE TABLE [Companies] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(max) NULL,
    [Address] nvarchar(max) NULL,
    [DateIncorporated] datetime2 NOT NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [DocumentTypes] (
    [Id] int NOT NULL IDENTITY,
    [Type] nvarchar(max) NULL,
    CONSTRAINT [PK_DocumentTypes] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [BusinessAccountManagers] (
    [Id] uniqueidentifier NOT NULL,
    [Email] nvarchar(max) NULL,
    [FirstName] nvarchar(max) NULL,
    [LastName] nvarchar(max) NULL,
    [PhotoUrl] nvarchar(max) NULL,
    [IsRegistered] bit NOT NULL DEFAULT CAST(0 AS bit),
    [CompanyId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_BusinessAccountManagers] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_BusinessAccountManagers_Companies_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Companies] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [ContactInformation] (
    [Id] uniqueidentifier NOT NULL,
    [Email] nvarchar(max) NULL,
    [Phone] nvarchar(max) NULL,
    [CompanyId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_ContactInformation] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ContactInformation_Companies_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Companies] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Customers] (
    [Id] uniqueidentifier NOT NULL,
    [CompanyName] nvarchar(max) NULL,
    [CreditLimit] int NULL,
    [Trn] int NOT NULL,
    [Address] nvarchar(max) NULL,
    [YearsOfBusiness] int NULL,
    [CompanyId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Customers_Companies_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Companies] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Documents] (
    [Id] uniqueidentifier NOT NULL,
    [DocumentId] nvarchar(max) NULL,
    [DocumentTypeId] int NOT NULL,
    [CustomerId] uniqueidentifier NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [CreatedAt] datetimeoffset NOT NULL,
    [LastModifiedAt] datetimeoffset NOT NULL,
    [LastModifiedBy] uniqueidentifier NOT NULL,
    [isActive] bit NOT NULL,
    CONSTRAINT [PK_Documents] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Documents_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Documents_DocumentTypes_DocumentTypeId] FOREIGN KEY ([DocumentTypeId]) REFERENCES [DocumentTypes] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Representatives] (
    [Id] uniqueidentifier NOT NULL,
    [FirstName] nvarchar(max) NULL,
    [LastName] nvarchar(max) NULL,
    [MiddleName] nvarchar(max) NULL,
    [DateOfBirth] datetime2 NOT NULL,
    [JobTitle] nvarchar(max) NULL,
    [GenderId] int NOT NULL,
    [Nationality] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    [ContactNumber] nvarchar(max) NULL,
    [Primary] bit NOT NULL,
    [CustomerId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Representatives] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Representatives_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Contracts] (
    [Id] uniqueidentifier NOT NULL,
    [status] nvarchar(max) NULL,
    [MonthlyPayment] real NOT NULL,
    [TotalCashPrice] real NOT NULL,
    [DeliveryDate] datetimeoffset NULL,
    [StartDateOfContract] datetimeoffset NULL,
    [EndDateOFContract] datetimeoffset NULL,
    [DateSigned] datetimeoffset NULL,
    [LastUpdated] datetimeoffset NOT NULL,
    [LastUpdatedBy] uniqueidentifier NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [CreatedOn] datetimeoffset NOT NULL,
    [isActive] bit NOT NULL,
    [RepresentativeId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Contracts_Representatives_RepresentativeId] FOREIGN KEY ([RepresentativeId]) REFERENCES [Representatives] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [Policies] (
    [Id] uniqueidentifier NOT NULL,
    [DeviceId] nvarchar(max) NULL,
    [Imei] nvarchar(max) NULL,
    [PolicyStartDate] datetimeoffset NOT NULL,
    [PolicyEndDate] datetimeoffset NOT NULL,
    [ContractId] uniqueidentifier NOT NULL,
    [CreatedBy] uniqueidentifier NOT NULL,
    [CreatedOn] datetimeoffset NOT NULL,
    [CompanyId] uniqueidentifier NOT NULL,
    [CustomerId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Policies] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Policies_Contracts_ContractId] FOREIGN KEY ([ContractId]) REFERENCES [Contracts] ([Id]) ON DELETE CASCADE
);

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Address', N'DateIncorporated', N'Name') AND [object_id] = OBJECT_ID(N'[Companies]'))
    SET IDENTITY_INSERT [Companies] ON;
INSERT INTO [Companies] ([Id], [Address], [DateIncorporated], [Name])
VALUES ('3b2195ec-d3cf-4106-f77e-08d746adadff', N'12 Ruthven Rd, Kingston', '2009-10-10T00:00:00.0000000', N'Smart Mobile Solutions');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Address', N'DateIncorporated', N'Name') AND [object_id] = OBJECT_ID(N'[Companies]'))
    SET IDENTITY_INSERT [Companies] OFF;

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[DocumentTypes]'))
    SET IDENTITY_INSERT [DocumentTypes] ON;
INSERT INTO [DocumentTypes] ([Id], [Type])
VALUES (1, N'DriversLicense_Front'),
(2, N'DriversLicense_Back'),
(3, N'Passport_Page1'),
(4, N'Passport_Page2'),
(5, N'VotersId_Back'),
(6, N'VotersId_Front'),
(7, N'Avatar'),
(8, N'JobLetter'),
(9, N'Proof_of_Address'),
(10, N'Proof_of_Income'),
(11, N'Proof_Of_Registration'),
(12, N'Letter_Of_Undertaking'),
(13, N'Contracts');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[DocumentTypes]'))
    SET IDENTITY_INSERT [DocumentTypes] OFF;

GO

CREATE INDEX [IX_BusinessAccountManagers_CompanyId] ON [BusinessAccountManagers] ([CompanyId]);

GO

CREATE INDEX [IX_ContactInformation_CompanyId] ON [ContactInformation] ([CompanyId]);

GO

CREATE INDEX [IX_Contracts_RepresentativeId] ON [Contracts] ([RepresentativeId]);

GO

CREATE INDEX [IX_Customers_CompanyId] ON [Customers] ([CompanyId]);

GO

CREATE INDEX [IX_Documents_CustomerId] ON [Documents] ([CustomerId]);

GO

CREATE INDEX [IX_Documents_DocumentTypeId] ON [Documents] ([DocumentTypeId]);

GO

CREATE INDEX [IX_Policies_ContractId] ON [Policies] ([ContractId]);

GO

CREATE INDEX [IX_Representatives_CustomerId] ON [Representatives] ([CustomerId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191211211217_InitialMigration', N'3.0.0');

GO

ALTER TABLE [Policies] ADD [PolicyNumber] int NOT NULL IDENTITY;

GO

ALTER TABLE [Contracts] ADD [ContractNumber] int NOT NULL IDENTITY;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191212151437_AddedAutoIncrementFieldToPolicyAndCustomerTable', N'3.0.0');

GO

ALTER TABLE [Contracts] ADD [DocumentId] uniqueidentifier NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191216222144_AddedDocumentIdToContractsTable', N'3.0.0');

GO

ALTER TABLE [Contracts] ADD [InvoiceDocumentId] uniqueidentifier NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191219223916_AddedInvioceDocumentIdToContractTable', N'3.0.0');

GO

ALTER TABLE [Contracts] ADD [OrderId] nvarchar(max) NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191220154537_AddedOrderIdToContractTable', N'3.0.0');

GO

CREATE TABLE [Genders] (
    [Id] int NOT NULL IDENTITY,
    [Type] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Genders] PRIMARY KEY ([Id])
);

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] ON;
INSERT INTO [Genders] ([Id], [Type])
VALUES (1, N'Male');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] OFF;

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] ON;
INSERT INTO [Genders] ([Id], [Type])
VALUES (2, N'Female');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] OFF;

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] ON;
INSERT INTO [Genders] ([Id], [Type])
VALUES (3, N'Unspecified');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[Genders]'))
    SET IDENTITY_INSERT [Genders] OFF;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200103185742_Added Gender Table', N'3.0.0');

GO

CREATE INDEX [IX_Representatives_GenderId] ON [Representatives] ([GenderId]);

GO

ALTER TABLE [Representatives] ADD CONSTRAINT [FK_Representatives_Genders_GenderId] FOREIGN KEY ([GenderId]) REFERENCES [Genders] ([Id]) ON DELETE CASCADE;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200103190225_Added Gender Foreign key to Representative Table', N'3.0.0');

GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[DocumentTypes]'))
    SET IDENTITY_INSERT [DocumentTypes] ON;
INSERT INTO [DocumentTypes] ([Id], [Type])
VALUES (14, N'Certification_Of_Incorporation'),
(15, N'Tax_Compliance_Certification'),
(16, N'Invoice'),
(17, N'Delivery_Slip');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Type') AND [object_id] = OBJECT_ID(N'[DocumentTypes]'))
    SET IDENTITY_INSERT [DocumentTypes] OFF;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200206195823_added_delivery_slip_param_to_contract_entity', N'3.0.0');

GO

ALTER TABLE [Contracts] ADD [DeliverySlipDocumentId] uniqueidentifier NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200207032107_added_delivery_slip_id_to_contracts', N'3.0.0');

GO


-- Inserts Script modify below --
-----------------------------------

-- Companies
SET IDENTITY_INSERT [business-customers].dbo.Companies ON;
GO

INSERT INTO [business-customers].dbo.Companies (Id, [Name], [Address], DateIncorporated) VALUES ('3B2195EC-D3CF-4106-F77E-08D746ADADFF', 'Smart Mobile Solutions', '12 Ruthven Rd, Kingston', '2009-10-10 00:00:00.0000000');
GO

SET IDENTITY_INSERT [business-customers].dbo.Companies OFF;
GO

-- Customers
SET IDENTITY_INSERT [business-customers].dbo.Customers ON;
GO

-- INSERT INTO [business-customers].dbo.Customers (Id, CompanyName, CreditLimit, Trn, Address, YearsOfBusiness, CompanyId) VALUES ('4631E87D-186B-4496-B059-08D77E7F607C', 'GelCo', 100, 111222333, '14 Ocean Blvd, Kingston', 9, '3B2195EC-D3CF-4106-F77E-08D746ADADFF');
-- GO

-- INSERT INTO [business-customers].dbo.Customers (Id, CompanyName, CreditLimit, Trn, Address, YearsOfBusiness, CompanyId) VALUES ('9C581C87-3EB5-4254-FF33-08D7A333EDD7', 'JC Penny', 100, 111222333, '14 Ocean Blvd, Kingston', 9, '3B2195EC-D3CF-4106-F77E-08D746ADADFF');
-- GO

SET IDENTITY_INSERT [business-customers].dbo.Customers OFF;
GO


--Representatives
SET IDENTITY_INSERT [business-customers].dbo.Representatives ON;
GO

-- INSERT INTO [business-customers].dbo.Representatives (Id, FirstName, LastName, MiddleName, DateOfBirth, JobTitle, GenderId, Nationality, Email, ContactNumber, [Primary], CustomerId) VALUES ('0701EB7F-390A-43D6-94C6-08D77E7F60E5', 'Akinyele', 'Thompson', 'Omowale', '1994-03-24 00:00:00.0000000', 'CEO', 1, 'Jamaican', 'akinyele@email.com', '18768887777', 1, '4631E87D-186B-4496-B059-08D77E7F607C');
-- GO

-- INSERT INTO [business-customers].dbo.Representatives (Id, FirstName, LastName, MiddleName, DateOfBirth, JobTitle, GenderId, Nationality, Email, ContactNumber, [Primary], CustomerId) VALUES ('4C608CE8-2F09-41E1-7906-08D7A333EE27', 'Howard', 'Edwards', 'Edwards', '1994-03-03 00:00:00.0000000', 'CEO', 1, null, 'howard.edwards@gmail.com', '87644138943', 1, '9C581C87-3EB5-4254-FF33-08D7A333EDD7');
-- GO 

SET IDENTITY_INSERT [business-customers].dbo.Representatives OFF;
GO

-- Contracts
--SET IDENTITY_INSERT dbo.Contracts ON;
--GO
--
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('16BBB926-8153-4609-3131-08D77F17C52B', 'Active', 100000, 100000000, null, null, null, null, '2019-12-12 10:27:16.4730550 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-12 10:27:16.4732490 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 1, null);
--GO
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('87F24994-31AB-4F80-3132-08D77F17C52B', 'Active', 100000, 100000000, null, null, null, null, '2019-12-12 10:27:53.5387990 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-12 10:27:53.5388320 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 2, null);
--GO
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('36FE53A3-1829-4644-14E1-08D77F1871EF', 'Active', 100001, 100000000, null, null, null, null, '2019-12-12 11:12:36.3825120 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-12 10:32:06.3383900 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 3, null);
--GO
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('5A2956B6-A755-47BE-2E45-08D7826CEFA1', 'Active', 100000, 100000000, null, null, null, null, '2019-12-16 16:14:28.4395640 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-16 16:14:28.4396250 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 1002, null);
--GO
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('4CD78623-DE4B-4771-2D9F-08D7826D4245', 'Active', 100000, 100000000, null, null, null, null, '2019-12-16 16:16:36.7000190 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-16 16:16:36.7001530 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 1003, null);
--GO
--INSERT INTO [business-customers].dbo.Contracts (Id, [status], MonthlyPayment, TotalCashPrice, DeliveryDate, StartDateOfContract, EndDateOFContract, DateSigned, LastUpdated, LastUpdatedBy, CreatedBy, CreatedOn, isActive, RepresentativeId, ContractNumber, DocumentId) VALUES ('1D8A8BA3-ACCE-4CD8-BF33-08D7826DA9FD', 'Active', 100000, 100000000, null, null, null, null, '2019-12-16 16:19:41.0940910 -05:00', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '3B2195EC-D3CF-4106-F77E-08D746ADADFF', '2019-12-16 16:19:41.0941500 -05:00', 1, 'B84930C4-0861-4FB8-B733-08D77F16698C', 1004, null);
--GO
--
--SET IDENTITY_INSERT dbo.Contracts OFF;
--GO