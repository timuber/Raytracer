//
//  Camera.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

final class Camera {
  private let origin: Point3
  private let horizontal: Vec3
  private let vertical: Vec3
  private let lowerLeftCorner: Point3
  
  init(aspectRatio: Double = 16.0/9.0) {
    let viewportHeight = 2.0
    let viewportWidth = aspectRatio * viewportHeight
    let focalLength = 1.0
    self.origin = Point3()
    self.horizontal = Vec3(x: viewportWidth, y: 0, z: 0)
    self.vertical = Vec3(x: 0, y: viewportHeight, z: 0)
    self.lowerLeftCorner = origin - horizontal / 2 - vertical / 2 - Vec3(x: 0, y: 0, z: focalLength)
  }
  
  func ray(u: Double, v: Double) -> Ray {
    Ray(
      origin: origin,
      dir: lowerLeftCorner + u * horizontal + v * vertical - origin)
  }
}
