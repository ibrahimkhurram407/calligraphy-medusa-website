// components/trigger-customer-update.tsx
"use client"

import { useTransition } from "react"
import { updateCustomer } from "@lib/data/customer"

import { HttpTypes } from "@medusajs/types"

interface customUpdateProps {
  customer: HttpTypes.StoreCustomer | null
}

const TriggerCustomerUpdate: React.FC<customUpdateProps> = ({
  customer
}) => {
  const [isPending, startTransition] = useTransition()

  const handleUnVerify= async () => {
    startTransition(async () => {
      try {
        await updateCustomer({ metadata: { email_verified: false } })
        console.log({ success: true })
      } catch (err: any) {
        console.error({ success: false, error: err.toString() })
      }
    })
  }
  const handleVerify= async () => {
    startTransition(async () => {
      try {
        await updateCustomer({ metadata: { email_verified: true } })
        console.log({ success: true })
      } catch (err: any) {
        console.error({ success: false, error: err.toString() })
      }
    })
  }

  return (
    <>
      {customer?.metadata?.email_verified &&
        <button
          className="mt-4 mr-2 px-4 py-2 bg-black text-white rounded"
          onClick={handleUnVerify}
          disabled={isPending}
        >
          {isPending ? "Updating..." : "Mark Email as Unverified"}
        </button>
      }
      {!customer?.metadata?.email_verified &&
        <button
          className="mt-4 px-4 py-2 bg-black text-white rounded"
          onClick={handleVerify}
          disabled={isPending}
        >
          {isPending ? "Updating..." : "Mark Email as Verified"}
        </button>
      }
    </>
    
  )
}

export default TriggerCustomerUpdate