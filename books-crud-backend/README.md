# Books CRUD Backend

This is a simple CRUD backend application for managing books. It is built using TypeScript and Express.js.

## Features

- Create, Read, Update, and Delete (CRUD) operations for books.
- TypeScript for type safety and better development experience.
- Express.js for handling HTTP requests.

## Project Structure

```
books-crud-backend
├── src
│   ├── app.ts                # Entry point of the application
│   ├── controllers
│   │   └── booksController.ts # Controller for handling book-related requests
│   ├── models
│   │   └── book.ts           # Book model definition
│   ├── routes
│   │   └── booksRoutes.ts     # Routes for book operations
│   └── types
│       └── index.ts          # Type definitions
├── package.json               # NPM package configuration
├── tsconfig.json              # TypeScript configuration
└── README.md                  # Project documentation
```

## Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd books-crud-backend
   ```

3. Install the dependencies:
   ```
   npm install
   ```

## Usage

To start the application, run:
```
npm start
```

The server will start on `http://localhost:3000`.

## API Endpoints

- `POST /books` - Create a new book
- `GET /books` - Retrieve all books
- `GET /books/:id` - Retrieve a book by ID
- `PUT /books/:id` - Update a book by ID
- `DELETE /books/:id` - Delete a book by ID

## License

This project is licensed under the MIT License.