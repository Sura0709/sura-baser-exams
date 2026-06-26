USE master;
GO

IF DB_ID(N'InfotechLibraryDb') IS NOT NULL
BEGIN
    ALTER DATABASE InfotechLibraryDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE InfotechLibraryDb;
END;
GO

CREATE DATABASE InfotechLibraryDb;
GO

USE InfotechLibraryDb;
GO

CREATE TABLE dbo.Categories(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Code NVARCHAR(10) NOT NULL UNIQUE,   
    Name NVARCHAR(100) NOT NULL          
);
GO

CREATE TABLE dbo.Books(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,         
    Publisher NVARCHAR(150) NULL,          
    PublishYear INT NULL,                         
    CategoryId INT NOT NULL,               

    CONSTRAINT FK_Books_Categories 
        FOREIGN KEY (CategoryId) REFERENCES Categories(Id)

);
GO

CREATE TABLE dbo.BookCopies(
    Id INT PRIMARY KEY IDENTITY(1,1),
    BookId INT NOT NULL,              
    CopyNumber INT NOT NULL,          
    ShelfCode NVARCHAR(50) NULL,      
    Status NVARCHAR(20) NOT NULL DEFAULT 'Available',
    

    CONSTRAINT FK_BookCopies_Books 
        FOREIGN KEY (BookId) REFERENCES Books(Id),

    CONSTRAINT UQ_Book_Copy UNIQUE (BookId, CopyNumber)
);
GO

CREATE TABLE dbo.Members(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CardNumber NVARCHAR(30) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    JoinDate DATE NOT NULL DEFAULT GETDATE(), 
    IsActive BIT NOT NULL DEFAULT 1        
);
GO

CREATE TABLE dbo.Loans(
    Id INT PRIMARY KEY IDENTITY(1,1),
    MemberId INT NOT NULL,        
    BookCopyId INT NOT NULL,      
    LoanDate DATETIME NOT NULL DEFAULT GETDATE(), 
    DeadlineDate DATETIME NOT NULL,                  
    ReturnDate DATETIME NULL,                   

    CONSTRAINT FK_Loans_Members 
        FOREIGN KEY (MemberId) REFERENCES Members(Id),

    CONSTRAINT FK_Loans_BookCopies 
        FOREIGN KEY (BookCopyId) REFERENCES BookCopies(Id)
);
GO

INSERT INTO dbo.Categories(Code, Name) VALUES
('ROM', 'Roman'),
('BIL', 'Bilim'),
('TAR', 'Tarih'),
('FEN', 'Fen Bilimleri'),
('PSK', 'Psikoloji');
GO

INSERT INTO dbo.Books (Title, Publisher, PublishYear, CategoryId)
VALUES
('Suç ve Ceza', 'İş Bankası Yayınları', 2019, 1),
('Kozmos', 'Sarmal Yayınları', 2020, 2),
('Nutuk', 'TTK Yayınları', 2006, 3),
('Fizik Dünyası', 'Bilim Kitap', 2021, 4),
('İnsan ve Davranış', 'PsikoPress', 2018, 5);
GO

INSERT INTO dbo.BookCopies (BookId, CopyNumber, ShelfCode, Status)
VALUES
(1, 1, 'A-01', 'Available'),
(1, 2, 'A-02', 'Borrowed'),
(2, 1, 'B-01', 'Available'),
(2, 2, 'B-02', 'Available'),
(3, 1, 'C-01', 'Borrowed'),
(4, 1, 'D-01', 'Available'),
(5, 1, 'E-01', 'Maintenance'),
(5, 2, 'E-02', 'Available');
GO

INSERT INTO dbo.Members (CardNumber, FullName, Email)
VALUES
('U1001', 'Ahmet Yılmaz', 'ahmet.yilmaz@mail.com'),
('U1002', 'Elif Demir', 'elif.demir@mail.com'),
('U1003', 'Mert Kaya', 'mert.kaya@mail.com'),
('U1004', 'Zeynep Arslan', 'zeynep.arslan@mail.com'),
('U1005', 'Burak Şahin', 'burak.sahin@mail.com');
GO

INSERT INTO dbo.Loans (MemberId, BookCopyId, DeadlineDate, ReturnDate)
VALUES
(1, 2, DATEADD(DAY, 14, GETDATE()), NULL), --ReturnDate-hala ödünçte yani
(2, 1, DATEADD(DAY, 7, GETDATE()), GETDATE()), --İade edilmiş
(3, 3, DATEADD(DAY, 10, GETDATE()), NULL),
(4, 5, DATEADD(DAY, 5, GETDATE()), NULL),
(5, 6, DATEADD(DAY, 12, GETDATE()), GETDATE());
GO


IF OBJECT_ID('dbo.usp_CheckoutBook','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CheckoutBook;
GO

CREATE PROCEDURE dbo.usp_CheckoutBook
(
    @MemberId INT,
    @BookCopyId INT,
    @LoanDays INT
)
AS
BEGIN
    
    BEGIN TRY
        IF @LoanDays <= 0
        BEGIN
            PRINT 'Ödünç süresi sıfırdan büyük olmalıdır.';
            RETURN;
        END;
        
        IF NOT EXISTS(SELECT 1 FROM dbo.Members m WHERE Id=@MemberId AND IsActive=1)
        BEGIN
            PRINT N'Üye bulunamadı veya üyelik aktif değil.';
            RETURN;
        END;

        IF NOT EXISTS(SELECT 1 FROM dbo.BookCopies b WHERE Id=@BookCopyId AND Status= 'Available')
        BEGIN
            PRINT N'Kitap kopyası müsait değil.';
            RETURN;
        END;

        IF EXISTS(SELECT 1 FROM dbo.Loans l WHERE BookCopyId=@BookCopyId AND ReturnDate IS NULL)
        BEGIN
            PRINT N'Bu kitap kopyası ödünç verilmiş.';
            RETURN;
        END;

        BEGIN TRANSACTION
        INSERT INTO dbo.Loans
        (
            MemberId,
            BookCopyId,
            DeadlineDate
        )
        VALUES
        (
            @MemberId,
            @BookCopyId,
            DATEADD(DAY, @LoanDays, GETDATE())
        );

        UPDATE dbo.BookCopies
        SET Status = 'Borrowed'
        WHERE Id = @BookCopyId;

        COMMIT TRANSACTION;

        PRINT 'Ödünç işlemi başarılı.';

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        PRINT 'Hata oluştu. İşlem geri alındı.';

    END CATCH

END;
GO

IF OBJECT_ID('dbo.usp_ReturnBook','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ReturnBook;
GO

CREATE PROCEDURE dbo.usp_ReturnBook
(
    @LoanId INT
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT 1 FROM dbo.Loans l WHERE Id=@LoanId AND ReturnDate IS NULL)
        BEGIN
            PRINT N'Geçerli aktif ödünç kaydı bulunamadı.';
            RETURN;
        END;

        BEGIN TRANSACTION;

        DECLARE @BookCopyId INT;

        SELECT @BookCopyId = BookCopyId
        FROM dbo.Loans
        WHERE Id = @LoanId;

        UPDATE dbo.Loans
        SET ReturnDate = GETDATE()
        WHERE Id = @LoanId;

        UPDATE dbo.BookCopies
        SET Status = 'Available'
        WHERE Id = @BookCopyId;

        COMMIT TRANSACTION;

        PRINT 'İade işlemi başarılı.';

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        PRINT 'Hata oluştu. İşlem geri alındı.';

    END CATCH

END;
GO

IF OBJECT_ID('dbo.v_ActiveLoansDetail','V') IS NOT NULL
    DROP VIEW dbo.v_ActiveLoansDetail;
GO

CREATE VIEW dbo.v_ActiveLoansDetail AS
SELECT
    l.Id,
    m.FullName,
    m.CardNumber,
    b.Title,
    c.Name,
    bc.ShelfCode,
    l.LoanDate,
    l.DeadLineDate,
    CASE WHEN l.DeadlineDate < GETDATE()
        THEN 'Yes'
        ELSE 'No'
    END AS IsOverdue
FROM dbo.loans l
    INNER JOIN dbo.Members m ON l.MemberId = m.Id
    INNER JOIN dbo.BookCopies bc ON l.BookCopyId = bc.Id
    INNER JOIN dbo.Books b ON bc.BookId = b.Id
    INNER JOIN dbo.Categories c ON b.CategoryId = c.Id
    WHERE l.ReturnDate IS NULL;
GO

--SELECT * FROM v_ActiveLoansDetail; çıktısı ne veriyor denetlemek için baktım.

-- LEFT JOIN örneği:
-- Hiç ödünç kaydı olmayan üyeler:

SELECT
    m.Id,
    m.FullName,
    m.CardNumber
FROM dbo.Members m

LEFT JOIN dbo.Loans l ON m.Id = l.MemberId
WHERE l.Id IS NULL;
GO

-- CTE örneği:
-- Gecikmiş ve henüz iade edilmemiş ödünçler:

WITH OverdueLoans AS
(
    SELECT
        Id,
        MemberId,
        DeadlineDate
    FROM dbo.Loans
    WHERE ReturnDate IS NULL AND DeadlineDate < GETDATE()
)

SELECT *
FROM OverdueLoans;
GO

--TEST KISMI 
--Testimde MemberId=3 , BookCopyId =4'ü kullanmaya karar verdim çünkü aktif üyeyle "available" durumda ve aktif ödüncü olmayanla uygun olacağını düşündüm.
--Ödünç Alma
EXEC dbo.usp_CheckoutBook 
    @MemberId=3, 
    @BookCopyId=4,
    @LoanDays=7;
-- burayı çalıştırdıktan sonra ödünç işlemi başarılı oldu.

--İade kısmı
DECLARE @NewLoanId INT;

SELECT TOP 1 @NewLoanId = Id
FROM dbo.Loans
ORDER BY Id DESC;

EXEC dbo.usp_ReturnBook @LoanId = @NewLoanId; -- bu satır iade ettiğmiz kısım.

SELECT bc.Status, l.ReturnDate
FROM dbo.BookCopies bc
JOIN dbo.Loans l ON l.BookCopyId = bc.Id
WHERE bc.Id = 4 AND l.Id = @NewLoanId;

--Testin sonucunda da sırayla deneyerek "mutlu test" e ulaşmış oldum.

        

        



            

       



