--CREATE DATABASE LIBRARYDB;
use LibraryDB;
-- Task 1: Define Tables with Constraints

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    CopiesAvailable INT DEFAULT 1 CHECK (CopiesAvailable >= 0)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LoanDate DATE DEFAULT GETDATE() NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Task 2: Populate Sample Data

INSERT INTO Books (BookID, Title, Author, Genre, CopiesAvailable) VALUES
(1, 'The Silent Patient', 'Alex Michaelides', 'Fiction', 5),
(2, 'Educated', 'Tara Westover', 'Memoir', 3),
(3, 'Atomic Habits', 'James Clear', 'Self-help', 2),
(4, '1984', 'George Orwell', 'Fiction', 4),
(5, 'The Alchemist', 'Paulo Coelho', 'Fiction', 6);

-- Insert into Members
INSERT INTO Members (MemberID, MemberName, Email) VALUES
(1, 'Alice Johnson', 'alice@gmail.com'),
(2, 'Bob Smith', 'bob@gmail.com'),
(3, 'Clara Nwachukwu', 'clara@gmail.com'),
(4, 'David Ola', 'david@gmail.com');

-- Insert into Loans
INSERT INTO Loans (LoanID, MemberID, BookID, LoanDate, ReturnDate) VALUES
(1, 1, 1, '2025-07-01', NULL),
(2, 1, 2, '2025-07-02', '2025-07-12'),
(3, 1, 3, '2025-07-03', NULL),
(4, 2, 1, '2025-07-04', '2025-07-15'),
(5, 2, 4, '2025-07-05', '2025-07-20'),
(6, 2, 5, '2025-07-06', '2025-07-19'),
(7, 3, 2, '2025-07-07', NULL),
(8, 3, 3, '2025-07-08', NULL),
(9, 4, 5, '2025-07-09', NULL),
(10, 4, 1, '2025-07-10', NULL);

-- Task 3: SQL Operations

-- CRUD on Books

-- INSERT
INSERT INTO Books (BookID, Title, Author, Genre, CopiesAvailable)
VALUES (6, 'Sapiens', 'Yuval Noah Harari', 'History', 7);

-- SELECT
SELECT * FROM Books;

-- UPDATE
UPDATE Books SET CopiesAvailable = 10 WHERE BookID = 3;

-- DELETE
DELETE FROM Books WHERE BookID = 6;

-- Filtering & Sorting
SELECT * FROM Books
WHERE Genre = 'Fiction'
ORDER BY Title ASC;

-- Aggregation: COUNT of loans per book
SELECT BookID, COUNT(*) AS TotalLoans
FROM Loans
GROUP BY BookID;

-- AVG CopiesAvailable
SELECT AVG(CopiesAvailable) AS AverageCopies
FROM Books;

-- JOIN: MemberName + count of currently loaned books (ReturnDate is NULL)
SELECT M.MemberName, COUNT(L.LoanID) AS ActiveLoans
FROM Members M
JOIN Loans L ON M.MemberID = L.MemberID
WHERE L.ReturnDate IS NULL
GROUP BY M.MemberName;

-- GROUP BY + HAVING: Members with more than 2 active loans
SELECT M.MemberName, COUNT(L.LoanID) AS ActiveLoans
FROM Members M
JOIN Loans L ON M.MemberID = L.MemberID
WHERE L.ReturnDate IS NULL
GROUP BY M.MemberName
HAVING COUNT(L.LoanID) > 2;

