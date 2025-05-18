import { retrieveCustomer } from "@lib/data/customer"
import { Toaster } from "@medusajs/ui"
import AccountLayout from "@modules/account/templates/account-layout"
import EmailVerificationPage from "@modules/account/components/email_verification"
import TriggerCustomerUpdate from "@modules/account/components/trigger-customer-update" // adjust path

export default async function AccountPageLayout({
  dashboard,
  login,
  email_verification
}: {
  dashboard?: React.ReactNode
  login?: React.ReactNode
  email_verification?: React.ReactNode
}) {
  const customer = await retrieveCustomer().catch(() => null)
  return (
    <AccountLayout customer={customer}>
      {customer ? customer.metadata?.email_verified ? dashboard : <EmailVerificationPage customer={customer} /> : login}
      {/* <TriggerCustomerUpdate customer={customer} /> */}
      <Toaster />
    </AccountLayout>
  )
}
