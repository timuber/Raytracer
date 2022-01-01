//
//  main.swift
//  Raytracer
//
//  Created by Timur Umayev on 1/1/22.
//

import Foundation

func rayColor(_ ray: Ray, _ world: Hittable) -> Color {
  var rec = HitRecord()
  if world.hit(ray: ray, min: 0, max: Double.infinity, rec: &rec) {
    return 0.5 * (rec.normal + Color(x: 1, y: 1, z: 1))
  }
  let normDirection = ray.dir.normalized
  let t = 0.5 * (normDirection.y + 1.0)
  return (1 - t) * Color(x: 1, y: 1, z: 1) + t * Color(x: 0.5, y: 0.7, z: 1)
}

func main() {
  // Image
  let aspectRatio: Double = 16.0/9.0
  let imageWidth = 400
  let imageHeight = Int(Double(imageWidth)/aspectRatio)
  let samplesPerPixel = 8
  
  // World
  let world = HittableList()
  world.add(Sphere(center: Point3(x: 0, y: 0, z: -1), radius: 0.5))
  world.add(Sphere(center: Point3(x: 0, y: -100.5, z: -1), radius: 100))
  
  // Camera
  let camera = Camera(aspectRatio: aspectRatio)

  // Output
  let url = URL(fileURLWithPath: "/Users/timuber/Desktop/image.ppm")
  let fileHandle = try! FileHandle(forWritingTo: url)
  var output = FileHandlerOutputStream(fileHandle)

  // Render

  print("P3\n\(imageWidth) \(imageHeight)\n255", to: &output)

  for j in stride(from: imageHeight - 1, through: 0, by: -1) {
    print("Scanlines remaining: \(j)")
    for i in stride(from: 0, to: imageWidth, by: 1) {
      var pixelColor = Color()
      for _ in 0..<samplesPerPixel {
        let u = (Double(i) + Double.random(in: 0..<1)) / Double(imageWidth-1)
        let v = (Double(j) + Double.random(in: 0..<1)) / Double(imageHeight-1)
        let ray = camera.ray(u: u, v: v)
        pixelColor += rayColor(ray, world)
      }
      printColor(pixelColor, samplesPerPixel: samplesPerPixel, to: &output)
    }
  }
}

main()
