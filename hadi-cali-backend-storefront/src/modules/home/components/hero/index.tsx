'use client'

import Image from "next/image"
import { Button, Heading, Text } from "@medusajs/ui"
import Link from "next/link"

const Hero = () => {
  return (
    <div className="w-full border-b border-ui-border-base bg-ui-bg-subtle">
      <div className="grid grid-cols-1 small:grid-cols-2 items-center min-h-[75vh] content-container gap-10 py-12">
        {/* Left: Text Section */}
        <div className="flex flex-col gap-6">
          <Heading level="h1" className="text-4xl font-semibold text-ui-fg-base">
            Tahreer
          </Heading>
          <Text className="text-lg text-ui-fg-subtle leading-relaxed">
            Discover handcrafted Islamic calligraphy rooted in tradition and beauty.
            Each piece is a timeless expression of spiritual artistry.
          </Text>
          <Link href="/store">
            <Button size="large">Explore Store</Button>
          </Link>
        </div>

        {/* Right: Image */}
        <div className="relative w-full h-[300px] small:h-[400px]">
          <Image
            src="/images/hero-section.png"
            alt="Islamic Calligraphy Frames"
            fill
            className="object-contain rounded-md shadow-lg"
            priority
          />
        </div>
      </div>
    </div>
  )
}

export default Hero
