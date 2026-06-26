DROP DATABASE IF EXISTS YazEtk;
GO

CREATE DATABESE YazEtk;
GO

USE YazEtk;
GO

CREATE TABLE dbo.Category(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Code NVARCHAR(10) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.Employees(
    Id INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    HireDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE ),
    Category_id INT NOT NULL,
    Notes NVARCHAR(500) NULL,

    CONSTRAINT FK_employees_category 
    FOREIGN KEY (category_id) REFERENCES dbo.Category(Id),
);
GO

CREATE TABLE dbo.Events(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CategoryId INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    StartDatetime  DATETIME2 NOT NULL,   
    EndDatetime DATETIME2 NOT NULL,

    CONSTRAINT FK_events_category 
    FOREIGN KEY (CategoryId) REFERENCES dbo.Category(Id),
    
    CONSTRAINT CK_Event_Time CHECK (EndDatetime > StartDatetime)
);
GO

CREATE TABLE dbo.VolunteerAssignments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    VolunteerId INT NOT NULL,
    EventId INT NOT NULL,
    RoleName NVARCHAR(100) NOT NULL,  
    EstimatedHours DECIMAL(5,2) NULL, 
    WorkLoadPercent INT NULL,         
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT UQ_Volunteer_Event UNIQUE (VolunteerId, EventId),

    CONSTRAINT FK_VA_Employee
    FOREIGN KEY (VolunteerId) REFERENCES dbo.Employees(Id),

    CONSTRAINT FK_VA_Event
    FOREIGN KEY (EventId) REFERENCES dbo.Events(Id),

    CONSTRAINT CK_WorkLoad CHECK (WorkLoadPercent BETWEEN 0 AND 100),
    CONSTRAINT CK_Hours CHECK (EstimatedHours >= 0)
);
GO

ALTER TABLE dbo.VolunteerAssignments
ADD Notes NVARCHAR(250) NULL;

INSERT INTO dbo.Category (Code, CategoryName) VALUES
('TECH', 'Teknoloji'),
('SOC', 'Sosyal Etkinlik'),
('EDU', 'Eğitim');
GO

INSERT INTO dbo.Employees (FullName, Email, Category_id, Notes) VALUES
('Ayşe Yılmaz', 'ayse@mail.com', 1, 'Frontend ilgileniyor'),
('Mehmet Demir', 'mehmet@mail.com', 2, 'Organizasyon tecrübeli'),
('Elif Kaya', 'elif@mail.com', 3, 'Eğitim gönüllüsü'),
('Can Aydın', 'can@mail.com', 1, 'Backend developer'),
('Zeynep Arslan', 'zeynep@mail.com', 2, 'Sosyal projelerde aktif');
GO

INSERT INTO dbo.Events (CategoryId, Name, StartDatetime, EndDatetime) VALUES
(1, 'Hackathon 2026', '2026-06-01 10:00', '2026-06-01 18:00'),
(2, 'Kariyer Günü', '2026-06-05 09:00', '2026-06-05 17:00'),
(3, 'Kodlama Atölyesi', '2026-06-10 13:00', '2026-06-10 16:00');
GO

INSERT INTO dbo.VolunteerAssignments 
(VolunteerId, EventId, RoleName, EstimatedHours, WorkLoadPercent)
VALUES
(1, 1, 'Kayıt Görevlisi', 3.50, 50),
(1, 2, 'Koordinatör', 5.00, 70),
(2, 1, 'Destek Personeli', 4.00, 60),
(3, 3, 'Eğitmen Yardımcısı', 2.50, 40),
(4, 1, 'Teknik Sorumlu', 6.00, 80),
(4, 3, 'Mentor', 3.00, 50),
(5, 2, 'Organizatör', 5.50, 75),
(2, 3, 'Kayıt Görevlisi', 2.00, 30);
GO

--SELECT 
    --e.Id,
    --e.FullName,
    --e.Email,
    --e.HireDate,
    --c.Name AS CategoryName,
    --c.Code AS CategoryCode
--FROM dbo.Employees e
--INNER JOIN dbo.Category c ON e.Category_id = c.Id
--WHERE e.HireDate >= '2023-01-01'
--ORDER BY c.Name, e.HireDate;

--SELECT 
--    e.Id AS VolunteerId,
--    e.FullName,
--    COUNT(DISTINCT va.EventId) AS EventCount
--FROM dbo.VolunteerAssignments va
--INNER JOIN dbo.Employees e ON va.VolunteerId = e.Id
--GROUP BY 
--    e.Id, 
--    e.FullName
--HAVING COUNT(DISTINCT va.EventId) >= 2;

SELECT * 
FROM dbo.Employees
WHERE HireDate < '2026-01-01';