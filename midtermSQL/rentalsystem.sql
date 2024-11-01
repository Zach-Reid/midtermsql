-- Creating the tables:
CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT CHECK (release_year > 1888),
    genre VARCHAR(100) NOT NULL,
    director VARCHAR(100) NOT NULL
);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number TEXT NOT NULL
);

CREATE TABLE Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    movie_id INT REFERENCES Movies(movie_id),
    rental_date DATE NOT NULL,
    return_date DATE NOT NULL
);

-- The sample data:

-- Sample movies
INSERT INTO Movies (title, release_year, genre, director) VALUES
('Space Jam', 1996, 'Comedy', 'Joe Pytka'),
('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
('Back to the Future', 1985, 'Sci-Fi', 'Robert Zemeckis'),
('Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino'),
('The Matrix', 1999, 'Sci-Fi', 'Lana Wachowski, Lilly Wachowski');

-- The sample customers
INSERT INTO Customers (first_name, last_name, email, phone_number) VALUES
('John', 'Johnson', 'john.johnson@gmail.com', '123-456-7890'),
('Susan', 'Smith', 'susansmith@outlook.com', '987-654-3210'),
('Alice', 'Angela', 'alice.a@yahoo.com', '555-123-4567'),
('Bob', 'Roberts', 'bobrob20@gmail.ca', '555-765-4321'),
('Jim', 'Davis', 'jimdavis@gmail.com', '555-000-0000');

-- Rental dates
INSERT INTO Rentals (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2023-10-01', '2023-10-15'),
(1, 2, '2023-10-05', '2023-10-12'),
(2, 1, '2023-10-02', '2023-10-16'),
(3, 3, '2023-10-03', '2023-10-20'),
(3, 4, '2023-10-10', '2023-10-25'),
(4, 5, '2023-10-11', '2023-10-18'),
(2, 3, '2023-10-08', '2023-10-22'),
(5, 1, '2023-10-05', '2023-10-19'),
(1, 4, '2023-10-12', '2023-10-29'),
(4, 2, '2023-10-14', '2023-10-28');

-- Some queries

-- Find all movies rented by a customer depending on their email
SELECT Movies.title 
FROM Rentals 
JOIN Customers ON Rentals.customer_id = Customers.customer_id 
JOIN Movies ON Rentals.movie_id = Movies.movie_id 
WHERE Customers.email = 'john.johnson@gmail.com';

-- List all customers that rented a movie, based on the name
SELECT Customers.first_name, Customers.last_name 
FROM Rentals 
JOIN Movies ON Rentals.movie_id = Movies.movie_id 
JOIN Customers ON Rentals.customer_id = Customers.customer_id 
WHERE Movies.title = 'Space Jam';

-- Check the rental history for a movie
SELECT Customers.first_name, Customers.last_name, Rentals.rental_date, Rentals.return_date 
FROM Rentals 
JOIN Movies ON Rentals.movie_id = Movies.movie_id 
JOIN Customers ON Rentals.customer_id = Customers.customer_id 
WHERE Movies.title = 'The Godfather';

-- For a specific movie director, find the name of the customer, the date of the rental, and title of the movie each time a movie by that director was rented.
SELECT Customers.first_name, Customers.last_name, Rentals.rental_date, Movies.title 
FROM Rentals 
JOIN Movies ON Rentals.movie_id = Movies.movie_id 
JOIN Customers ON Rentals.customer_id = Customers.customer_id 
WHERE Movies.director = 'Quentin Tarantino';

-- List all currently rented out movies (movies whose return dates haven't been met).
SELECT Movies.title 
FROM Rentals 
JOIN Movies ON Rentals.movie_id = Movies.movie_id 
WHERE Rentals.return_date > NOW();



