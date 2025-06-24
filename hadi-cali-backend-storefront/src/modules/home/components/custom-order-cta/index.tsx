import { Button, Heading, Text } from "@medusajs/ui"
import Link from "next/link"

const CustomOrderCTA = () => {
  return (
    <div className="py-16 text-center bg-ui-bg-subtle">
      <Heading level="h2" className="text-xl mb-4">
        Want a Personalized Piece?
      </Heading>
      <Text className="text-ui-fg-subtle mb-6">
        Order a unique calligraphy artwork with your preferred verse, name, or message
      </Text>
      <Link href="/custom-order">
        <Button>Request a Custom Order</Button>
      </Link>
    </div>
  )
}

export default CustomOrderCTA