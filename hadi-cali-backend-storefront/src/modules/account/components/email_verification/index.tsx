"use client"

import React, { useEffect, useState } from "react"
import { updateCustomer } from "@lib/data/customer"

import { HttpTypes } from "@medusajs/types"

const BACKEND_URL = 'https://backend.tahreer.shop'
const PUBLISHABLE_API_KEY = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY

interface customUpdateProps {
  customer: HttpTypes.StoreCustomer | null
}

const EmailVerificationPage: React.FC<customUpdateProps> = ({
  customer
}) => {
  const [emailCode, setEmailCode] = useState("")
  const [message, setMessage] = useState("")

  const customerId = customer?.id

  const handleSendCode = async () => {
    if (!emailCode || !customerId) {
      setMessage("Missing code or customer.")
      return
    }

    try {
      const res = await fetch(`${BACKEND_URL}/store/customer/verify-otp`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-publishable-api-key": PUBLISHABLE_API_KEY!,
        },
        body: JSON.stringify({
          id: customerId,
          otp: emailCode,
        }),
      })

      const json = await res.json()
      if (!res.ok) throw new Error(json.message)

      setMessage("✅ Email verified successfully.")
      await updateCustomer({ metadata: { otp: 0 } })

    } catch (err: any) {
      setMessage(`❌ Verification failed: ${err.message}`)
    }
  }

  const requestCode = async () => {
    if (!customerId) {
      setMessage("Customer not found.")
      return
    }

    try {
      const res = await fetch(`${BACKEND_URL}/store/customer/send-otp`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-publishable-api-key": PUBLISHABLE_API_KEY!,
        },
        body: JSON.stringify({ id: customerId }),
      })

      const json = await res.json()
      if (!res.ok) throw new Error(json.message)
      setMessage("📨 OTP sent successfully.")
    } catch (err: any) {
      setMessage(`❌ Failed to send OTP: ${err.message}`)
    }
  }

  return (
    <div className="bg-white px-4 pt-6 sm:px-6 lg:px-8">
      <div className="w-full max-w-sm sm:max-w-md mx-auto space-y-4">
        {customer?.email ? (
          <p>
            Please verify your email to use website features. Email Address: {customer.email}
          </p>
        ) : (
          <p>Please verify your email to use website features. No email address found.</p>
        )}



        <div className="flex flex-col sm:flex-row sm:items-center gap-2">
          
          <input
            type="text"
            placeholder="Enter verification code"
            value={emailCode}
            onChange={(e) => setEmailCode(e.target.value)}
            className="w-full border border-gray-300 rounded px-3 py-2 text-sm"
          />
          <button
            onClick={handleSendCode}
            className="w-full sm:w-auto bg-black text-white text-sm px-4 py-2 rounded"
          >
            Check OTP
          </button>
        </div>

        <button
          onClick={requestCode}
          className="w-full bg-black text-white text-sm px-4 py-2 rounded"
        >
          Get New OTP
        </button>

        {message && (
          <div className="text-xs text-center text-gray-600">{message}</div>
        )}
      </div>
    </div>
  )
}

export default EmailVerificationPage
