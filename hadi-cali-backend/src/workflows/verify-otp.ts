// src/workflows/verify-otp.ts
import {
  createWorkflow,
  WorkflowResponse,
  createStep,
  StepResponse,
} from "@medusajs/framework/workflows-sdk"
import { Modules } from "@medusajs/framework/utils"

// STEP: Verify OTP and set email_verified
const verifyOtpStep = createStep(
  "verify-customer-otp",
  async (
    { customerId, otp }: { customerId: string; otp: string },
    { container }
  ) => {
    const customerModuleService = container.resolve(Modules.CUSTOMER)

    const customer = await customerModuleService.retrieveCustomer(customerId)

    if (!customer) {
      throw new Error(`Customer with ID ${customerId} not found.`)
    }

    if (!customer.metadata?.otp || customer.metadata.otp !== otp) {
      throw new Error("Invalid OTP")
    }

    // Update email_verified = true
    await customerModuleService.updateCustomers(customerId, {
      metadata: {
        email_verified: true,
      },
    })

    return new StepResponse({ verified: true })
  }
)

// WORKFLOW
export const verifyOtpWorkflow = createWorkflow(
  "verify-customer-otp",
  (input: { customerId: string; otp: string }) => {
    const { verified } = verifyOtpStep(input)
    return new WorkflowResponse({ verified })
  }
)
