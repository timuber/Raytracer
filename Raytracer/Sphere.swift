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
  
  init() {
    self.center = Point3()
    self.radius = 0
  }
  
  init(center: Point3, radius: Double) {
    self.center = center
    self.radius = radius
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
    
    return true
  }
}
