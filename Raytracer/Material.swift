//
//  Material.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

protocol Material {
  func scatter(ray: Ray, rec: HitRecord, attenuation: inout Color, scattered: inout Ray) -> Bool
}

final class Lambertian: Material {
  let albedo: Color
  
  init(albedo: Color) {
    self.albedo = albedo
  }
  
  func scatter(ray: Ray, rec: HitRecord, attenuation: inout Color, scattered: inout Ray) -> Bool {
    var scatterDir = rec.normal + Vec3.randomUnitVector()
    if scatterDir.isNearZero {
      scatterDir = rec.normal
    }
    scattered = Ray(origin: rec.point, dir: scatterDir)
    attenuation = albedo
    return true
  }
}

final class Metal: Material {
  let albedo: Color
  let fuzz: Double
  
  init(albedo: Color, fuzz: Double = 0) {
    self.albedo = albedo
    self.fuzz = min(fuzz, 1)
  }
  
  func scatter(ray: Ray, rec: HitRecord, attenuation: inout Color, scattered: inout Ray) -> Bool {
    let reflected = reflect(ray.dir.normalized, rec.normal)
    scattered = Ray(origin: rec.point, dir: reflected + fuzz * Vec3.randomInUnitSphere())
    attenuation = albedo
    return dot(scattered.dir, rec.normal) > 0
  }
}

final class Dielectric: Material {
  let indexOfRefraction: Double
  
  init(indexOfRefraction: Double) {
    self.indexOfRefraction = indexOfRefraction
  }
  
  func scatter(ray: Ray, rec: HitRecord, attenuation: inout Color, scattered: inout Ray) -> Bool {
    attenuation = Color(x: 1, y: 1, z: 1)
    let refractionRatio = rec.isFrontFace ? (1/indexOfRefraction) : indexOfRefraction
    let unitDirection = ray.dir.normalized
    let cosTheta = min(dot(-unitDirection, rec.normal), 1.0)
    let sinTheta = sqrt(1 - cosTheta*cosTheta)
    let cantRefract = refractionRatio * sinTheta > 1.0
    let direction: Vec3
    if cantRefract || reflectance(cosTheta, refractionRatio) > Double.random(in: 0..<1) {
      direction = reflect(unitDirection, rec.normal)
    } else {
      direction = refract(vector: unitDirection, normal: rec.normal, refractiveIndexRatio: refractionRatio)
    }
    scattered = Ray(origin: rec.point, dir: direction)
    return true
  }
  

}

private func reflectance(_ cosine: Double, _ refIdx: Double) -> Double {
  // Use Schlick's approximation for reflectance
  var r0 = (1 - refIdx) / (1 + refIdx)
  r0 = r0 * r0
  return r0 + (1 - r0) * pow(1 - cosine, 5)
}
