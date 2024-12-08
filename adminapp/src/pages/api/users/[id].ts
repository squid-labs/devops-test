import { NextApiRequest, NextApiResponse } from 'next';

const BACKEND_URL = 'http://localhost:8080';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { id } = req.query;

  try {
    if (req.method === 'PUT') {
      const response = await fetch(`${BACKEND_URL}/users/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(req.body),
      });
      const data = await response.json();
      return res.status(200).json(data);
    }

    if (req.method === 'DELETE') {
      const response = await fetch(`${BACKEND_URL}/users/${id}`, {
        method: 'DELETE',
      });
      return res.status(204).end();
    }

    res.setHeader('Allow', ['PUT', 'DELETE']);
    return res.status(405).end(`Method ${req.method} Not Allowed`);
  } catch (error) {
    console.error('API Error:', error);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
}
