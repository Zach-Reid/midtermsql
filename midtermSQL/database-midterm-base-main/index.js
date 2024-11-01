const { Pool } = require('pg');

// PostgreSQL connection
const pool = new Pool({
  user: 'postgres',
  host: 'localhost', 
  database: 'postgres',
  password: 'pass1',
  port: 5432, 
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  const createMoviesTable = `
    CREATE TABLE IF NOT EXISTS Movies (
      movie_id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      release_year INT NOT NULL,
      genre VARCHAR(100),
      director VARCHAR(100)
    );
  `;

  const createCustomersTable = `
    CREATE TABLE IF NOT EXISTS Customers (
      customer_id SERIAL PRIMARY KEY,
      first_name VARCHAR(100),
      last_name VARCHAR(100),
      email VARCHAR(100) UNIQUE,
      phone VARCHAR(15)
    );
  `;

  const createRentalsTable = `
    CREATE TABLE IF NOT EXISTS Rentals (
      rental_id SERIAL PRIMARY KEY,
      customer_id INT REFERENCES Customers(customer_id),
      movie_id INT REFERENCES Movies(movie_id),
      rental_date DATE NOT NULL,
      return_date DATE
    );
  `;

  await pool.query(createMoviesTable);
  await pool.query(createCustomersTable);
  await pool.query(createRentalsTable);
}

/**
 * Inserts a new movie into the Movies table.
 */
async function insertMovie(title, year, genre, director) {
  try {
    const result = await pool.query(
      'INSERT INTO Movies (title, release_year, genre, director) VALUES ($1, $2, $3, $4)',
      [title, year, genre, director]
    );
    console.log('Movie inserted:', result);
  } catch (err) {
    console.error('Error inserting movie:', err);
  }
}

/**
 * Prints all movies in the database to the console.
 */
async function displayMovies() {
  try {
    const result = await pool.query('SELECT * FROM Movies');
    console.log(result.rows);
  } catch (err) {
    console.error('Error fetching movies:', err);
  }
}

/**
 * Updates a customer's email address.
 */
async function updateCustomerEmail(customerId, newEmail) {
  try {
    const result = await pool.query(
      'UPDATE Customers SET email = $1 WHERE customer_id = $2',
      [newEmail, customerId]
    );
    console.log('Customer email updated:', result);
  } catch (err) {
    console.error('Error updating email:', err);
  }
}

/**
 * Removes a customer from the database along with their rental history.
 */
async function removeCustomer(customerId) {
  try {
    await pool.query('DELETE FROM Rentals WHERE customer_id = $1', [customerId]);
    await pool.query('DELETE FROM Customers WHERE customer_id = $1', [customerId]);
    console.log('Customer removed:', customerId);
  } catch (err) {
    console.error('Error removing customer:', err);
  }
}

/**
 * Prints a help message to the console.
 */
function printHelp() {
  console.log('Usage:');
  console.log('  insert <title> <year> <genre> <director> - Insert a movie');
  console.log('  show - Show all movies');
  console.log('  update <customer_id> <new_email> - Update a customer\'s email');
  console.log('  remove <customer_id> - Remove a customer from the database');
}

/**
 * Runs our CLI app to manage the movie rentals database.
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case 'insert':
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case 'show':
      await displayMovies();
      break;
    case 'update':
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case 'remove':
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
}

runCLI();


