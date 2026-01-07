import { listCategories } from "@lib/data/categories"
import { listCollections } from "@lib/data/collections"
import { Text, clx } from "@medusajs/ui"

import LocalizedClientLink from "@modules/common/components/localized-client-link"
import MedusaCTA from "@modules/layout/components/medusa-cta"

export default async function Footer() {
  const { collections } = await listCollections({ fields: "*products" })
  const productCategories = await listCategories()

  return (
    <footer className="border-t border-ui-border-base w-full">
      <div className="content-container flex flex-col w-full py-12">
        <div className="grid grid-cols-1 small:grid-cols-3 gap-10 mb-10">
          {/* Logo + Instagram */}
          <div className="flex flex-col gap-3">
            <LocalizedClientLink
              href="/"
              className="txt-compact-xlarge-plus text-ui-fg-subtle hover:text-ui-fg-base uppercase"
            >
              Tahreer
            </LocalizedClientLink>
            <div>
              <span className="txt-small-plus txt-ui-fg-base block mb-1">
                Follow us on Instagram
              </span>
              <a
                href="https://instagram.com/tahreerpk"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-ui-fg-base underline"
              >
                @tahreerpk
              </a>
            </div>

            <div className="mt-4">
              <span className="txt-small-plus txt-ui-fg-base block mb-1">
                Follow us on Facebook
              </span>
              <a
                href="https://www.facebook.com/share/1M1NQEMB46/?mibextid=wwXIfr"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-ui-fg-base underline"
              >
                facebook.com
              </a>
            </div>

            <div className="mt-4">
              <span className="txt-small-plus txt-ui-fg-base block mb-1">
                Follow us on YouTube
              </span>
              <a
                href="https://www.youtube.com/@Tahreer.132"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-ui-fg-base underline"
              >
                @Tahreer.132
              </a>
            </div>

            <div className="mt-4">
              <span className="txt-small-plus txt-ui-fg-base block mb-1">
                Follow us on TikTok
              </span>
              <a
                href="https://www.tiktok.com/@tahreer132"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:text-ui-fg-base underline"
              >
                @tahreer132
              </a>
            </div>


          </div>

          {/* Categories */}
          {productCategories?.length > 0 && (
            <div className="flex flex-col gap-2">
              <span className="txt-small-plus txt-ui-fg-base">Categories</span>
              <ul className="grid gap-2 txt-small text-ui-fg-subtle">
                {productCategories.slice(0, 6).map((c) => {
                  if (c.parent_category) return null
                  return (
                    <li key={c.id}>
                      <LocalizedClientLink
                        className="hover:text-ui-fg-base"
                        href={`/categories/${c.handle}`}
                      >
                        {c.name}
                      </LocalizedClientLink>
                    </li>
                  )
                })}
              </ul>
            </div>
          )}

          {/* Collections */}
          {collections?.length > 0 && (
            <div className="flex flex-col gap-2">
              <span className="txt-small-plus txt-ui-fg-base">Collections</span>
              <ul className="grid gap-2 txt-small text-ui-fg-subtle">
                {collections.slice(0, 6).map((c) => (
                  <li key={c.id}>
                    <LocalizedClientLink
                      className="hover:text-ui-fg-base"
                      href={`/collections/${c.handle}`}
                    >
                      {c.title}
                    </LocalizedClientLink>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>

        <div className="flex justify-between text-ui-fg-muted text-compact-small">
          <Text>© {new Date().getFullYear()} Tahreer. All rights reserved.</Text>
        </div>
      </div>
    </footer>
  )
}
