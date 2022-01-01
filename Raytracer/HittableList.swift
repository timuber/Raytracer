//
//  HittableList.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

final class HittableList {
  private(set) var objects: [Hittable]
  
  init(objects: [Hittable] = []) {
    self.objects = objects
  }
  
  func clear() {
    objects.removeAll()
  }
  
  func add(_ object: Hittable) {
    objects.append(object)
  }
}

extension HittableList: Hittable {
  
  func hit(ray: Ray, min: Double, max: Double, rec: inout HitRecord) -> Bool {
    var tempRec = HitRecord()
    var hitAnything = false
    var closestSoFar = max
    
    for obj in objects {
      if obj.hit(ray: ray, min: min, max: closestSoFar, rec: &tempRec) {
        hitAnything = true
        closestSoFar = tempRec.t
        rec = tempRec
      }
    }
    
    return hitAnything
  }
}
