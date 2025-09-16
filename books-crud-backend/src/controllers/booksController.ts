import { Request, Response } from 'express';
import { Book, sequelize } from '../models/book';

export class BooksController {
    async createBook(req: Request, res: Response) {
        const { title, author, publishedDate } = req.body;
        try {
            const newBook = await Book.create({
                title,
                author,
                publishedDate: new Date(publishedDate)
            });
            res.status(201).json(newBook);
        } catch (err) {
            res.status(500).json({ error: 'Failed to create book' });
        }
    }

    async getBooks(req: Request, res: Response) {
        try {
            const books = await Book.findAll();
            res.json(books);
        } catch (err) {
            res.status(500).json({ error: 'Failed to fetch books' });
        }
    }

    async getBookById(req: Request, res: Response) {
        try {
            const book = await Book.findByPk(+req.params.id);
            if (book) {
                res.json(book);
            } else {
                res.status(404).send('Book not found');
            }
        } catch (err) {
            res.status(500).json({ error: 'Failed to fetch book' });
        }
    }

    async updateBook(req: Request, res: Response) {
        const { title, author, publishedDate } = req.body;
        try {
            const book = await Book.findByPk(+req.params.id);
            if (!book) return res.status(404).send('Book not found');
            await book.update({ title, author, publishedDate: new Date(publishedDate) });
            res.json(book);
        } catch (err) {
            res.status(500).json({ error: 'Failed to update book' });
        }
    }

    async deleteBook(req: Request, res: Response) {
        try {
            const book = await Book.findByPk(+req.params.id);
            if (!book) return res.status(404).send('Book not found');
            await book.destroy();
            res.json(book);
        } catch (err) {
            res.status(500).json({ error: 'Failed to delete book' });
        }
    }
}