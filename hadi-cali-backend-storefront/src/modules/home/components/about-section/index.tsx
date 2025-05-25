import { Heading, Text } from "@medusajs/ui"

const AboutSection = () => {
  return (
    <div className="content-container py-16 text-center">
      <Heading level="h2" className="text-2xl mb-4">
        About Tahreer
      </Heading>
      <Text className="text-ui-fg-subtle max-w-2xl mx-auto">
        Tahreer is a celebration of Islamic heritage, offering handcrafted calligraphy that blends traditional techniques with timeless elegance. Each piece is thoughtfully created to inspire and beautify your space.
      </Text>
    </div>
  )
}
export default AboutSection