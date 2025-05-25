// app/page.tsx (Main Landing Page)
import { Metadata } from "next"

import FeaturedProducts from "@modules/home/components/featured-products"
import Hero from "@modules/home/components/hero"
import AboutSection from "@modules/home/components/about-section"
import CategoryGrid from "@modules/home/components/category-grid"
import CustomOrderCTA from "@modules/home/components/custom-order-cta"
import { listCollections } from "@lib/data/collections"
import { getRegion } from "@lib/data/regions"

export const metadata: Metadata = {
  title: "Tahreer Store",
  description:
    "Discover handcrafted pieces rooted in tradition and beauty",
}

export default async function Home(props: {
  params: Promise<{ countryCode: string }>
}) {
  const params = await props.params

  const { countryCode } = params

  const region = await getRegion(countryCode)

  const { collections } = await listCollections({
    fields: "id, handle, title",
  })

  if (!collections || !region) {
    return null
  }

  return (
    <>
      <Hero />
      <AboutSection />
      <CategoryGrid />
      <div className="py-12">
        <ul className="flex flex-col gap-x-6">
          <FeaturedProducts collections={collections} region={region} />
        </ul>
      </div>
      <CustomOrderCTA />
    </>
  )
}
