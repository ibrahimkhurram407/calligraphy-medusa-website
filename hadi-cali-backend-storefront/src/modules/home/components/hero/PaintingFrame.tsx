'use client'

import { useGLTF } from '@react-three/drei'
import { useFrame } from '@react-three/fiber'
import { useRef, useState } from 'react'
import { Group, Vector3, PointLight } from 'three'

// Shared hover state
let isAnyHovered = false

type Props = {
  modelPath: string
  finalPosition: [number, number, number]
  rotation?: [number, number, number]
}

export function PaintingFrame({ modelPath, finalPosition, rotation }: Props) {
  const groupRef = useRef<Group>(null)
  const lightRef = useRef<PointLight>(null)
  const { scene } = useGLTF(modelPath)

  const [start] = useState(() => {
    const rand = () => (Math.random() - 0.5) * 30
    return new Vector3(rand(), rand(), 0)
  })

  if (rotation) {
    scene.rotation.set(...rotation)
  }

  useFrame(() => {
    if (!groupRef.current) return

    const targetY = isAnyHovered && groupRef.current.userData.hovered ? finalPosition[1] + 0.3 : finalPosition[1]

    groupRef.current.position.lerp(
      new Vector3(finalPosition[0], targetY, finalPosition[2]),
      0.05
    )

    if (lightRef.current) {
      lightRef.current.intensity = isAnyHovered ? 4 : 0
    }
  })

  const handlePointerOver = () => {
    isAnyHovered = true
    if (groupRef.current) groupRef.current.userData.hovered = true
  }

  const handlePointerOut = () => {
    isAnyHovered = false
    if (groupRef.current) groupRef.current.userData.hovered = false
  }

  return (
    <group
      ref={groupRef}
      position={start.toArray()}
      onPointerOver={handlePointerOver}
      onPointerOut={handlePointerOut}
    >
      <primitive object={scene} scale={1} />
      <pointLight
        ref={lightRef}
        intensity={0} // start off
        distance={10}
        color="yellow"
        position={[2, 1.1, 0]} // ✅ above the frame, relative to group center
        decay={2}
      />

    </group>
  )
}
