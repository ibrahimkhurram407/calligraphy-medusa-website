// import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http";
// import { ContainerRegistrationKeys } from "@medusajs/utils"

// export async function GET(
//   req: MedusaRequest,
//   res: MedusaResponse
// ) {
//   res.sendStatus(200);
// }


// export const POST = async (req: MedusaRequest, res: MedusaResponse) => {
//   const customerId = req.body?.id;

//   if (!customerId) {
//     return res.status(401).json({ message: "Unauthorized" })
//   }

//   const { email, first_name, last_name, metadata } = req.body

//   const customerService = req.scope.resolve(ContainerRegistrationKeys.CUSTOMER_SERVICE)

//   try {
//     const updatedCustomer = await customerService.update(customerId, {
//       email,
//       first_name,
//       last_name,
//       metadata,
//     })

//     return res.status(200).json({ customer: updatedCustomer })
//   } catch (err) {
//     return res.status(500).json({ message: "Error updating customer", error: err.message })
//   }
// }


import { ContainerRegistrationKeys } from "@medusajs/utils"

// export async function GET(req: MedusaRequest, res: MedusaResponse) {
//   res.sendStatus(200)
// }

import type {
  MedusaRequest,
  MedusaResponse,
} from "@medusajs/framework/http"
import { sendOtpWorkflow } from "../../../../workflows/send-email-otp"


export async function POST(req: MedusaRequest, res: MedusaResponse) {
  const body = req.body as { id: string }
  const customerId = body?.id
  if (!customerId) {
    return res.status(401).json({ message: "Unauthorized" })
  }
  

  
  try {
    const { result } = await sendOtpWorkflow(req.scope).run({
      input: { customerId: customerId }
    })

    return res.status(200).json( {"result": "success"} )
  } catch (err: any) {
    return res.status(500).json({
      message: "Error updating customer",
      error: err.message,
    })
  }
}
