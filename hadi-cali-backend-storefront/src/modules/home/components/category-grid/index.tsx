// components/category-grid.tsx
import { Heading } from "@medusajs/ui"
import Link from "next/link"

const categories = [
  { title: "Quranic Verses", href: "/categories/quranic-verses" },
  { title: "Minimalist Arabic Designs", href: "/categories/minimal-calligraphy" }
]

const CategoryGrid = () => {
  return (
    <div className="content-container py-16">
      <Heading level="h2" className="text-xl mb-8 text-center">
        Shop by Category
      </Heading>
      <div className="grid grid-cols-1 small:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {categories.map((cat) => (
          <Link
            key={cat.title}
            href={cat.href}
            className="border border-ui-border-base rounded hover:shadow-md flex items-center justify-center text-center h-28 p-4 transition-all duration-200 ease-in-out"
          >
            <span className="text-base font-medium text-ui-fg-base">{cat.title}</span>
          </Link>
        ))}
      </div>
    </div>
  )
}

export default CategoryGrid
