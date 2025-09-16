"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BooksController = void 0;
class BooksController {
    constructor() {
        this.books = [];
        this.currentId = 1;
    }
    createBook(req, res) {
        const { title, author, publishedDate } = req.body;
        const newBook = { id: this.currentId++, title, author, publishedDate };
        this.books.push(newBook);
        res.status(201).json(newBook);
    }
    getBooks(req, res) {
        res.json(this.books);
    }
    getBookById(req, res) {
        const book = this.books.find(book => book.id === +req.params.id);
        if (book) {
            res.json(book);
        }
        else {
            res.status(404).send('Book not found');
        }
    }
    updateBook(req, res) {
        const bookIndex = this.books.findIndex(book => book.id === +req.params.id);
        if (bookIndex !== -1) {
            const { title, author, publishedDate } = req.body;
            this.books[bookIndex] = { id: +req.params.id, title, author, publishedDate };
            res.json(this.books[bookIndex]);
        }
        else {
            res.status(404).send('Book not found');
        }
    }
    deleteBook(req, res) {
        const bookIndex = this.books.findIndex(book => book.id === +req.params.id);
        if (bookIndex !== -1) {
            const deletedBook = this.books.splice(bookIndex, 1);
            res.json(deletedBook[0]);
        }
        else {
            res.status(404).send('Book not found');
        }
    }
}
exports.BooksController = BooksController;
