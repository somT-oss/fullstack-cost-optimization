import { Router, Application } from 'express';
import { BooksController } from '../controllers/booksController';

const router = Router();
const booksController = new BooksController();

export function setBooksRoutes(app: Application) {
    app.post('/books', booksController.createBook.bind(booksController));
    app.get('/books', booksController.getBooks.bind(booksController));
    app.get('/books/:id', booksController.getBookById.bind(booksController));
    app.put('/books/:id', booksController.updateBook.bind(booksController));
    app.delete('/books/:id', booksController.deleteBook.bind(booksController));
}