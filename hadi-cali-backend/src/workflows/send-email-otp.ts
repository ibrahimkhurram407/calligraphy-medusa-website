import {
  createWorkflow,
  WorkflowResponse,
  createStep,
  StepResponse,
} from "@medusajs/framework/workflows-sdk"
import { Modules } from "@medusajs/framework/utils"
import nodemailer from "nodemailer"

// STEP: Generate OTP and email to customer
const sendOtpToCustomerStep = createStep(
  "send-otp-to-customer",
  async ({ customerId }: { customerId: string }, { container }) => {
    const customerModuleService = container.resolve(Modules.CUSTOMER)

    // Fetch customer by ID
    const customer = await customerModuleService.retrieveCustomer(customerId)

    if (!customer) {
      throw new Error(`Customer with ID ${customerId} not found.`)
    }

    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString()

    // Update metadata with OTP
    await customerModuleService.updateCustomers(
      customerId,
      {
        metadata: {
          ...customer.metadata,
          otp,
        },
      },
    )

    // Send OTP via email using nodemailer
    const transporter = nodemailer.createTransport({
      host: "smtpout.secureserver.net", // Replace this
      port: 465,
      secure: true,
      auth: {
        user: "care@tahreer.online", // Replace this
        pass: 'y2UkMy674vy"',    // Replace this
      },
    })

    await transporter.sendMail({
      from: 'care@tahreer.online',
      to: customer.email,
      subject: "Your OTP Code",
      text: `Your one-time password is: ${otp}`,
    })

    return new StepResponse({ otp })
  }
)

// WORKFLOW: Accepts customerId and sends OTP
export const sendOtpWorkflow = createWorkflow(
  "send-otp-to-customer",
  (input: { customerId: string }) => {
    const { otp } = sendOtpToCustomerStep(input)
    return new WorkflowResponse({ otp })
  }
)
