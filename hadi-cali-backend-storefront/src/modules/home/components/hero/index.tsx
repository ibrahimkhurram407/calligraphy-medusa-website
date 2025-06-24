// Hero.tsx
'use client'

import { Canvas, useThree } from '@react-three/fiber'
import { Suspense, useEffect, useState } from 'react'
import { PerspectiveCamera } from 'three'
import { PaintingFrame } from "./PaintingFrame"
import Image from "next/image"
import { Button, Heading, Text } from "@medusajs/ui"
import Link from "next/link"

function ResponsiveCameraWrapper({ children }: { children: React.ReactNode }) {
  const { camera, size } = useThree()

  useEffect(() => {
    const baseFov = 45
    let adjustedFov = baseFov

    switch (true) {
      case size.width < 400:
        adjustedFov = 85
        break
      case size.width < 600:
        adjustedFov = 75
        break
      case size.width < 800:
        adjustedFov = 65
        break
      case size.width < 1000:
        adjustedFov = 55
        break
      default:
        adjustedFov = 45
    }

    const cam = camera as PerspectiveCamera
    cam.fov = adjustedFov
    cam.updateProjectionMatrix()
  }, [size, camera])

  return <>{children}</>
}

const Hero = () => {
  const [isMobile, setIsMobile] = useState(false)

  useEffect(() => {
    const handleResize = () => setIsMobile(window.innerWidth < 600)
    handleResize()
    window.addEventListener('resize', handleResize)
    return () => window.removeEventListener('resize', handleResize)
  }, [])

  if (isMobile) {
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

  return (
    <div className="relative w-full min-h-[calc(100vh-80px)] overflow-hidden bg-ui-bg-subtle">
      <div className="absolute inset-0 ">
        <Canvas camera={{ position: [0, 0, 5], fov: 45 }}>
          <ResponsiveCameraWrapper>
            <Suspense fallback={null}>
              <ambientLight intensity={0.4} />
              <directionalLight position={[10, 10, 10]} intensity={1} />

              {/* Frames flying in from random positions to fixed destinations */}
              <PaintingFrame modelPath="/models/frame1.glb" finalPosition={[-1.2, -0.7, -1.7]} rotation={[0, -1.9, 0]} />
              <PaintingFrame modelPath="/models/frame3.glb" finalPosition={[-1.4, -0.7, -1]} rotation={[0, -1.65, 0]} />
              <PaintingFrame modelPath="/models/frame2.glb" finalPosition={[-2.3, -0.7, -1]} rotation={[0, -1.2, 0]} />
            </Suspense>
          </ResponsiveCameraWrapper>
        </Canvas>
      </div>

      <div className="relative z-10 flex flex-col items-start justify-center px-6 py-12 h-full max-w-4xl mx-auto">
        <h1 className="text-5xl font-bold text-ui-fg-base mb-4">Tahreer</h1>
        <p className="text-lg text-ui-fg-subtle leading-relaxed mb-6">
          Discover handcrafted Islamic calligraphy rooted in tradition and beauty.
          Each piece is a timeless expression of spiritual artistry.
        </p>
        <a href="/store">
          <button className="bg-black text-white px-6 py-3 rounded-md hover:bg-yellow-500 transition-colors duration-300">
            Explore Store
          </button>
        </a>
      </div>
    </div>
  )
}

export default Hero
