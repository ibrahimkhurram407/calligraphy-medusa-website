// src/api/customers/verify-otp/route.ts
import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { verifyOtpWorkflow } from "../../../../workflows/verify-otp"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const body = req.body as { id?: string; otp?: string }

  const customerId = body?.id
  const otp = body?.otp

  if (!customerId || !otp) {
    return res.status(400).json({ message: "Missing id or otp" })
  }

  try {
    const { result } = await verifyOtpWorkflow(req.scope).run({
      input: { customerId, otp },
    })

    return res.status(200).json(result)
  } catch (err: any) {
    return res.status(401).json({
      message: err.message || "OTP verification failed",
    })
  }
}
