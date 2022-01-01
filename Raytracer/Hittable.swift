//
//  Hittable.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

final class HitRecord {
  var point = Point3()
  var normal = Vec3()
  var t = 0.0
  var isFrontFace = false
  var material: Material? = nil
  
  func setFaceNormal(ray: Ray, outwardNormal: Vec3) {
    isFrontFace = dot(ray.dir, outwardNormal) < 0
    normal = isFrontFace ? outwardNormal : -outwardNormal
  }
}

protocol Hittable {
  func hit(ray: Ray, min: Double, max: Double, rec: inout HitRecord) -> Bool
}
