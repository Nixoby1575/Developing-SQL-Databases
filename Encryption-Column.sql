use Clinic

-- Crear tabla con columnas encriptadas
CREATE TABLE [dbo].[Patients](
[PatientId] [int] IDENTITY(1,1),
[SSN] [nvarchar] (11) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (ENCRYPTION_TYPE = DETERMINISTIC,
ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256',
COLUMN_ENCRYPTION_KEY = CEK1) NOT NULL,
[FirsName] [nvarchar](50) NULL,
[LastName] [nvarchar](50) NULL,
[MiddleName] [nvarchar](50) NULL,
[StreetAddress] [nvarchar](50) NULL,
[City] [nvarchar](50) NULL,
[ZipCode] [int] NULL,
[State] [nvarchar](50) NULL,
[BirthDate] [datetime2]
ENCRYPTED WITH (ENCRYPTION_TYPE = RANDOMIZED, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256',
COLUMN_ENCRYPTION_KEY = CEK1) NOT NULL
PRIMARY KEY CLUSTERED ([PatientId] ASC) ON [PRIMARY] )
GO
-- Intento de Inserción
Insert into Patients (SSN, FirstName, LastName, MiddleName, Birthdate) values
(5235434554, 'Victor', 'Cardenes', 'H','1976-0125');
