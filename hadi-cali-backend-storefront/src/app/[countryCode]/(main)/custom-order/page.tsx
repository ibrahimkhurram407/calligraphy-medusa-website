'use client'

import { useState } from 'react'
import { Button, Input, Textarea } from '@medusajs/ui'

const BACKEND_URL = 'https://backend.tahreer.shop'
const PUBLISHABLE_API_KEY = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY

const CustomOrderPage = () => {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [message, setMessage] = useState('')
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent' | 'error'>('idle')
  const [responseMessage, setResponseMessage] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setStatus('sending')

    try {
      const res = await fetch(`${BACKEND_URL}/store/custom-order`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key': PUBLISHABLE_API_KEY!,
        },
        body: JSON.stringify({ name, email, message }),
      })

      const data = await res.json()

      if (!res.ok) throw new Error(data.message || 'Failed to send request')

      setStatus('sent')
      setResponseMessage('✅ Custom order request sent successfully.')
      setName('')
      setEmail('')
      setMessage('')
    } catch (err: any) {
      setStatus('error')
      setResponseMessage(`❌ ${err.message}`)
    }
  }

  return (
    <div className="content-container py-16 max-w-xl mx-auto">
      <h1 className="text-2xl font-semibold mb-6">Request a Custom Order</h1>
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <Input
          required
          placeholder="Your Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <Input
          required
          type="email"
          placeholder="Your Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <Textarea
          required
          rows={5}
          placeholder="Describe your custom request"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
        />
        <Button type="submit" disabled={status === 'sending'}>
          {status === 'sending' ? 'Sending...' : 'Send Request'}
        </Button>
        {responseMessage && (
          <p className={`text-sm text-center ${status === 'sent' ? 'text-green-600' : 'text-red-600'}`}>
            {responseMessage}
          </p>
        )}
      </form>
    </div>
  )
}

export default CustomOrderPage
