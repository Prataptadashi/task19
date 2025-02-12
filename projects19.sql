CREATE DATABASE LibraryDB;

USE LibraryDB;

CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT,
    available INT DEFAULT 1, -- 1 = available, 0 = borrowed
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE SET NULL
);
CREATE TABLE Members (
    member_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);
CREATE TABLE BorrowedBooks (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT GETDATE(),
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);
INSERT INTO Authors (name) VALUES ('F. Scott Fitzgerald'), ('J.K. Rowling'), ('George Orwell');
INSERT INTO Books (title, author_id) 
VALUES ('The Great Gatsby', (SELECT author_id FROM Authors WHERE name = 'F. Scott Fitzgerald'));
INSERT INTO Members (name, email) 
VALUES ('John Doe', 'john.doe@example.com');
INSERT INTO BorrowedBooks (book_id, member_id) 
VALUES ((SELECT book_id FROM Books WHERE title = 'The Great Gatsby'), 
        (SELECT member_id FROM Members WHERE email = 'john.doe@example.com'));

UPDATE Books 
SET available = 0 
WHERE book_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby');


UPDATE BorrowedBooks 
SET return_date = GETDATE() 
WHERE book_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby') 
AND member_id = (SELECT member_id FROM Members WHERE email = 'john.doe@example.com') 
AND return_date IS NULL;

UPDATE Books 
SET available = 1 
WHERE book_id = (SELECT book_id FROM Books WHERE title = 'The Great Gatsby');


SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Members;
SELECT * FROM BorrowedBooks;
