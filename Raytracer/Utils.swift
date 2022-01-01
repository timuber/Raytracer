//
//  Utils.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

func degToRad(_ deg: Double) -> Double {
  return deg * Double.pi / 180.0
}

func clamp(_ val: Double, _ mn: Double, _ mx: Double) -> Double {
  if val < mn { return mn }
  if val > mx { return mx }
  return val
}

func printColor<Target>(_ color: Color, samplesPerPixel: Int = 1, to output: inout Target) where Target : TextOutputStream {
  var r = color.x
  var g = color.y
  var b = color.z
  
  let scale = 1.0 / Double(samplesPerPixel)
  r *= scale
  g *= scale
  b *= scale
  
  let ir = Int(256 * clamp(r, 0, 0.999))
  let ig = Int(256 * clamp(g, 0, 0.999))
  let ib = Int(256 * clamp(b, 0, 0.999))
  print("\(ir) \(ig) \(ib)", to: &output)
}
