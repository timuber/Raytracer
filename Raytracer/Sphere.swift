//
//  Sphere.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

final class Sphere {
  let center: Point3
  let radius: Double
  let material: Material
  
  init(center: Point3 = Point3(), radius: Double = 0, material: Material) {
    self.center = center
    self.radius = radius
    self.material = material
  }
}

extension Sphere: Hittable {
  
  func hit(ray: Ray, min: Double, max: Double, rec: inout HitRecord) -> Bool {
    let oc = ray.origin - center
    let a = ray.dir.lengthSquared
    let halfB = dot(oc, ray.dir)
    let c = oc.lengthSquared - radius * radius
    let discriminant = halfB * halfB - a * c
    if discriminant < 0 {
      return false
    }
    let sqrtd = sqrt(discriminant)
    
    var root = (-halfB - sqrtd) / a
    if root < min || root > max {
      root = (-halfB + sqrtd) / a
      if root < min || root > max {
        return false
      }
    }
    
    rec.t = root
    rec.point = ray.at(root)
    let outwardNormal = (rec.point - center) / radius
    rec.setFaceNormal(ray: ray, outwardNormal: outwardNormal)
    rec.material = material
    
    return true
  }
}
