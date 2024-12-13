import { Server as NetServer } from 'http'
import { NextApiRequest } from 'next'
import { Server as ServerIO } from 'socket.io'
import { Server as SocketIOServer } from 'socket.io'
import { Socket as ClientSocket } from 'socket.io-client'
import { io as ClientIO } from 'socket.io-client'

export const config = {
  api: {
    bodyParser: false,
  },
}

const BACKEND_URL = process.env.NEXT_PUBLIC_BACKEND_URL

const ioHandler = (req: NextApiRequest, res: any) => {
  if (!res.socket.server.io) {
    const httpServer: NetServer = res.socket.server as any
    const io = new ServerIO(httpServer, {
      path: '/api/socket',
      cors: {
        origin: '*',
      },
    })

    // Connect to backend socket
    const backendSocket = ClientIO(BACKEND_URL)

    io.on('connection', (socket) => {
      console.log('Client connected to proxy')

      // Forward messages from client to backend
      socket.on('message', (message) => {
        backendSocket.emit('message', message)
      })

      // Forward responses from backend to client
      backendSocket.on('response', (response) => {
        socket.emit('response', response)
      })

      socket.on('disconnect', () => {
        console.log('Client disconnected from proxy')
      })
    })

    res.socket.server.io = io
  }
  res.end()
}

export default ioHandler
