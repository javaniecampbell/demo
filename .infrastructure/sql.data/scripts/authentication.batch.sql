-- DECLARE @dbname varchar(128)
-- SET @dbname = N'OnboardingAuthDB'

-- IF (NOT EXISTS (SELECT name 
-- FROM master.dbo.sysdatabases 
-- WHERE ('[' + name + ']' = @dbname 
-- OR name = @dbname)))
-- BEGIN
CREATE DATABASE OnboardingAuthDB;
-- END;
GO
USE OnboardingAuthDB;
GO
-- Generated Script modify below --
-----------------------------------
IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] varchar(150) NOT NULL,
        [ProductVersion] varchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

CREATE TABLE [AspNetRoles] (
    [Id] varchar(450) NOT NULL,
    [Name] varchar(256) NULL,
    [NormalizedName] varchar(256) NULL,
    [ConcurrencyStamp] varchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [AspNetUsers] (
    [Id] varchar(450) NOT NULL,
    [UserName] varchar(256) NULL,
    [NormalizedUserName] varchar(256) NULL,
    [Email] varchar(256) NULL,
    [NormalizedEmail] varchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] varchar(max) NULL,
    [SecurityStamp] varchar(max) NULL,
    [ConcurrencyStamp] varchar(max) NULL,
    [PhoneNumber] varchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    [FirstName] varchar(max) NULL,
    [LastName] varchar(max) NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] varchar(450) NOT NULL,
    [ClaimType] varchar(max) NULL,
    [ClaimValue] varchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] varchar(450) NOT NULL,
    [ClaimType] varchar(max) NULL,
    [ClaimValue] varchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] varchar(450) NOT NULL,
    [ProviderKey] varchar(450) NOT NULL,
    [ProviderDisplayName] varchar(max) NULL,
    [UserId] varchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [AspNetUserRoles] (
    [UserId] varchar(450) NOT NULL,
    [RoleId] varchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

GO

CREATE TABLE [AspNetUserTokens] (
    [UserId] varchar(450) NOT NULL,
    [LoginProvider] varchar(450) NOT NULL,
    [Name] varchar(450) NOT NULL,
    [Value] varchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

GO

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);

GO

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;

GO

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);

GO

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);

GO

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);

GO

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);

GO

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20190606210459_InitialMigration', N'2.2.4-servicing-10062');

GO

DROP INDEX [UserNameIndex] ON [AspNetUsers];

GO

DROP INDEX [RoleNameIndex] ON [AspNetRoles];

GO

CREATE TABLE [RefreshTokens] (
    [Token] varchar(450) NOT NULL,
    [JwtId] varchar(max) NULL,
    [CreationDate] datetime2 NOT NULL,
    [ExpiryDate] datetime2 NOT NULL,
    [IsUsed] bit NOT NULL,
    [IsInvalidated] bit NOT NULL,
    [UserId] varchar(450) NULL,
    CONSTRAINT [PK_RefreshTokens] PRIMARY KEY ([Token]),
    CONSTRAINT [FK_RefreshTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION
);

GO

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]);

GO

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]);

GO

CREATE INDEX [IX_RefreshTokens_UserId] ON [RefreshTokens] ([UserId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191019171836_AddedRefreshToken', N'2.2.4-servicing-10062');

GO