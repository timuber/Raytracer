//
//  Vector.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

typealias Point3 = Vec3
typealias Color = Vec3

final class Vec3 {
  var x: Double
  var y: Double
  var z: Double
  
  init() {
    self.x = 0
    self.y = 0
    self.z = 0
  }
  
  init(x: Double, y: Double, z: Double) {
    self.x = x
    self.y = y
    self.z = z
  }
  
  static func += (left: inout Vec3, right: Vec3) {
    left.x += right.x
    left.y += right.y
    left.z += right.z
  }
  
  static func *= (left: inout Vec3, t: Double) {
    left.x *= t
    left.y *= t
    left.z *= t
  }
  
  static func /= (left: inout Vec3, t: Double) {
    left *= 1/t
  }
  
  static prefix func - (vector: Vec3) -> Vec3 {
    return Vec3(x: -vector.x, y: -vector.y, z: -vector.z)
  }
  
  var lengthSquared: Double {
    return x * x + y * y + z * z
  }
  
  var length: Double {
    return sqrt(lengthSquared)
  }
}

extension Vec3: CustomStringConvertible {
  var description: String {
    return "\(x) \(y) \(z)"
  }
}

extension Vec3 {
  static func + (left: Vec3, right: Vec3) -> Vec3 {
    return Vec3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
  }
  
  static func - (left: Vec3, right: Vec3) -> Vec3 {
    return Vec3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
  }
  
  static func * (left: Vec3, right: Vec3) -> Vec3 {
    return Vec3(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
  }
  
  static func * (left: Vec3, t: Double) -> Vec3 {
    return Vec3(x: left.x * t, y: left.y * t, z: left.z * t)
  }
  
  static func * (t: Double, v: Vec3) -> Vec3 {
    return v * t
  }
  
  static func / (v: Vec3, t: Double) -> Vec3 {
    return v * (1/t)
  }
  
  var normalized: Vec3 {
    return self / self.length
  }
}

extension Vec3 {
  static func random(min: Double = 0.0, max: Double = 1.0) -> Vec3 {
    Vec3(x: Double.random(in: min..<max),
         y: Double.random(in: min..<max),
         z: Double.random(in: min..<max))
  }
  
  static func randomInUnitSphere() -> Vec3 {
    while true {
      let p = Vec3.random(min: -1, max: 1)
      if p.lengthSquared >= 1 { continue }
      return p
    }
  }
  
  static func randomUnitVector() -> Vec3 {
    return randomInUnitSphere().normalized
  }
  
  static func randomInHemisphere(normal: Vec3) -> Vec3 {
    let unitSphere = Vec3.randomInUnitSphere()
    return dot(unitSphere, normal) > 0 ? unitSphere : -unitSphere
  }
}

extension Vec3 {
  var isNearZero: Bool {
    let epsilon = 0.00000001
    return abs(x) < epsilon && abs(y) < epsilon && abs(z) < epsilon
  }
}

func dot(_ left: Vec3, _ right: Vec3) -> Double {
  return left.x * right.x + left.y * right.y + left.z * right.z
}

func cross(_ left: Vec3, _ right: Vec3) -> Vec3 {
  return Vec3(x: left.y * right.z - left.z * right.y,
              y: left.z * right.x - left.x * right.z,
              z: left.x * right.y - left.y * right.x)
}

func reflect(_ vec: Vec3, _ normal: Vec3) -> Vec3 {
  return vec - 2 * dot(vec, normal) * normal
}

func refract(vector: Vec3, normal: Vec3, refractiveIndexRatio: Double) -> Vec3 {
  let cosTheta = min(dot(-vector, normal), 1.0)
  let refractPerp = refractiveIndexRatio * (vector + cosTheta * normal)
  let refractParallel = -sqrt(abs(1.0 - refractPerp.lengthSquared)) * normal
  return refractPerp + refractParallel
}
