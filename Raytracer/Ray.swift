//
//  Ray.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

final class Ray {
  let origin: Point3
  let dir: Vec3
  
  init() {
    self.origin = Point3()
    self.dir = Vec3()
  }
  
  init(origin: Point3, dir: Vec3) {
    self.origin = origin
    self.dir = dir
  }
  
  func at(_ t: Double) -> Point3 {
    return origin + t * dir
  }
}
