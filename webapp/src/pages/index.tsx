import { useEffect, useState } from 'react';
import localFont from "next/font/local";
import io from 'socket.io-client';

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});

const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

export default function Home() {
  const [socket, setSocket] = useState<any>(null);
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState<string[]>([]);

  useEffect(() => {
    const newSocket = io({
      path: '/api/socket',
    });
    setSocket(newSocket);

    newSocket.on('response', (response: { data: string }) => {
      setMessages((prevMessages) => [...prevMessages, response.data]);
    });

    return () => {
      newSocket.close();
    };
  }, []);

  const sendMessage = (e: React.FormEvent) => {
    e.preventDefault();
    if (message.trim() && socket) {
      socket.emit('message', message);
      setMessage('');
    }
  };

  return (
    <div className={`${geistSans.variable} ${geistMono.variable} min-h-screen p-8`}>
      <div className="max-w-2xl mx-auto">
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6">
          <div className="h-96 overflow-y-auto mb-4 space-y-2">
            {messages.map((msg, index) => (
              <div key={index} className="p-2 bg-gray-100 dark:bg-gray-700 rounded">
                {msg}
              </div>
            ))}
          </div>
          <form onSubmit={sendMessage} className="flex gap-2">
            <input
              type="text"
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              className="flex-1 p-2 border rounded dark:bg-gray-700 dark:border-gray-600"
              placeholder="Type your message..."
            />
            <button
              type="submit"
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
              Send
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
