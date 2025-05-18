import { Metadata } from "next"

// import LoginTemplate from "@modules/account/templates/login-template"
import EmailVerificationLayout from "@modules/account/components/email_verification"

export const metadata: Metadata = {
  title: "Verify your Email",
  description: "Verify your email address.",
}

export default function EmailVerificationTemplate() {
  return <EmailVerificationLayout />
}
