"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setBooksRoutes = void 0;
const express_1 = require("express");
const booksController_1 = require("../controllers/booksController");
const router = (0, express_1.Router)();
const booksController = new booksController_1.BooksController();
function setBooksRoutes(app) {
    app.post('/books', booksController.createBook.bind(booksController));
    app.get('/books', booksController.getBooks.bind(booksController));
    app.get('/books/:id', booksController.getBookById.bind(booksController));
    app.put('/books/:id', booksController.updateBook.bind(booksController));
    app.delete('/books/:id', booksController.deleteBook.bind(booksController));
}
exports.setBooksRoutes = setBooksRoutes;
