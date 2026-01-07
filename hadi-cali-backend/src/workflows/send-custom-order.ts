// workflows/send-custom-order.ts
import {
  createWorkflow,
  WorkflowResponse,
  createStep,
  StepResponse,
} from "@medusajs/framework/workflows-sdk"
import nodemailer from "nodemailer"

const sendCustomOrderEmailStep = createStep(
  "send-custom-order-email",
  async (
    {
      name,
      email,
      message,
    }: { name: string; email: string; message: string },
    { container }
  ) => {
    const transporter = nodemailer.createTransport({
      host: "smtpout.secureserver.net", // Replace this
      port: 465,
      secure: true,
      auth: {
        user: "care@tahreer.online", // Replace this
        pass: 'y2UkMy674vy',    // Replace this
      },
    })

    await transporter.sendMail({
      from: 'care@tahreer.online',
      to: 'ibrahimkhurram407@gmail.com',
      subject: "New Custom Calligraphy Order",
      html: `
        <h2>New Custom Order Request</h2>
        <p><strong>Name:</strong> ${name}</p>
        <p><strong>Email:</strong> ${email}</p>
        <p><strong>Message:</strong><br/>${message.replace(/\n/g, "<br/>")}</p>
      `,
    })

    return new StepResponse({ success: true })
  }
)

export const sendCustomOrderWorkflow = createWorkflow(
  "send-custom-order",
  (input: { name: string; email: string; message: string }) => {
    const { success } = sendCustomOrderEmailStep(input)
    return new WorkflowResponse({ success })
  }
)
