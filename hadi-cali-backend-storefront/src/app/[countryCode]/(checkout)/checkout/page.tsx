import { retrieveCart } from "@lib/data/cart"
import { retrieveCustomer } from "@lib/data/customer"
import PaymentWrapper from "@modules/checkout/components/payment-wrapper"
import CheckoutForm from "@modules/checkout/templates/checkout-form"
import CheckoutSummary from "@modules/checkout/templates/checkout-summary"
import EmailVerificationPage from "@modules/account/components/email_verification/index"
import { Metadata } from "next"
import { notFound } from "next/navigation"
import LoginTemplate from "@modules/account/templates/login-template"

export const metadata: Metadata = {
  title: "Checkout",
}

export enum LOGIN_VIEW {
  SIGN_IN = "sign-in",
  REGISTER = "register",
}

export default async function Checkout() {
  const cart = await retrieveCart()

  if (!cart) {
    return notFound()
  }

  const customer = await retrieveCustomer()

  return (
    <div className="grid grid-cols-1 small:grid-cols-[1fr_416px] content-container gap-x-40 py-12">
      {customer && customer.metadata?.email_verified ? (
        <PaymentWrapper cart={cart}>
          <CheckoutForm cart={cart} customer={customer} />
        </PaymentWrapper>
      ) : customer ? (
        <EmailVerificationPage customer={customer} />
      ) : (
        <LoginTemplate />
      )}

      <CheckoutSummary cart={cart} />
    </div>

  )
}
