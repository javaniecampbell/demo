CREATE DATABASE [ShoppingCartMSDb];
GO
USE [ShoppingCartMSDb];
GO

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

CREATE TABLE [Carts] (
    [CartId] uniqueidentifier NOT NULL,
    [DateCreatedOn] datetime2 NOT NULL,
    [DateModifiedOn] datetime2 NOT NULL,
    [CustomerId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY ([CartId])
);

GO

CREATE TABLE [Orders] (
    [OrderId] uniqueidentifier NOT NULL,
    [CustomerId] uniqueidentifier NOT NULL,
    [Status] nvarchar(max) NULL,
    [CreatedOn] datetime2 NOT NULL,
    [DeliveredOn] datetime2 NULL,
    [ModifiedOn] datetime2 NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderId])
);

GO

CREATE TABLE [CartItem] (
    [Id] int NOT NULL IDENTITY,
    [CartId] uniqueidentifier NOT NULL,
    [ProductId] nvarchar(450) NOT NULL,
    [Quantity] int NOT NULL,
    CONSTRAINT [PK_CartItem] PRIMARY KEY ([Id], [CartId], [ProductId]),
    CONSTRAINT [FK_CartItem_Carts_CartId] FOREIGN KEY ([CartId]) REFERENCES [Carts] ([CartId]) ON DELETE CASCADE       );


CREATE TABLE [OrderItem] (
    [Id] int NOT NULL IDENTITY,
    [OrderId] uniqueidentifier NOT NULL,
    [ProductId] nvarchar(450) NOT NULL,
    [Quantity] int NOT NULL,
    CONSTRAINT [PK_OrderItem] PRIMARY KEY ([Id], [OrderId], [ProductId]),
    CONSTRAINT [FK_OrderItem_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId]) ON DELETE CASCADE );

GO

CREATE INDEX [IX_CartItem_CartId] ON [CartItem] ([CartId]);

GO

CREATE INDEX [IX_OrderItem_OrderId] ON [OrderItem] ([OrderId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191202160311_ShoppingCartV1Schema', N'3.0.1');

GO