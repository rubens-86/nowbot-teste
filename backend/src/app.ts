import express, { Request, Response } from 'express';
import { createServer } from 'http';
import cors from 'cors';

const app = express();

app.use(cors());
app.use(express.json());

// Rota de verificação de saúde
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

export default createServer(app); 