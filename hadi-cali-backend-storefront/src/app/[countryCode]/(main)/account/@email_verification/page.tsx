import { Metadata } from "next"
import { retrieveCustomer } from "@lib/data/customer"
// import LoginTemplate from "@modules/account/templates/login-template"
import EmailVerificationLayout from "@modules/account/components/email_verification"

export const metadata: Metadata = {
  title: "Verify your Email",
  description: "Verify your email address.",
}

export default async function EmailVerificationTemplate() {
  const customer = await retrieveCustomer().catch(() => null)
  return <EmailVerificationLayout customer={customer} />
}
