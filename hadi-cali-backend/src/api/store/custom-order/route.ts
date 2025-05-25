// api/store/custom-order.ts
import type { MedusaRequest, MedusaResponse } from "@medusajs/framework/http"
import { sendCustomOrderWorkflow } from "../../../workflows/send-custom-order"

export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
  const { name, email, message } = req.body as {
  name: string
  email: string
  message: string
}


  if (!name || !email || !message) {
    return res.status(400).json({ message: "Missing required fields" })
  }

  try {
    const { result } = await sendCustomOrderWorkflow(req.scope).run({
      input: { name, email, message },
    })

    return res.status(200).json({ message: "Custom order sent", result })
  } catch (err: any) {
    return res.status(500).json({
      message: "Failed to process custom order",
      error: err.message,
    })
  }
}
