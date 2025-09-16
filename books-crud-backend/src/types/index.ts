export interface Book {
    id: string;
    title: string;
    author: string;
    publishedDate: Date;
}

import { Request, Response } from 'express';

export type CustomRequest = Request;
export type CustomResponse = Response;