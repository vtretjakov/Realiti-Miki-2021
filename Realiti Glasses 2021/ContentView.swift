//
//  ContentView.swift
//  Realiti Glasses 2021
//
//  Created by Владимир on 27.09.2021.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func createBox() -> Entity {
        // Create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create entity based on mesh
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    func createCircle(x: Float = 0, y: Float = 0, z: Float = 0 ) -> Entity {
        
        // Create circle mesh (круговая сетка, ячейка)
        let circle = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // Create material
        let material = SimpleMaterial(color: .black, isMetallic: true)
        
        // create entity
        let circleEntity = ModelEntity(mesh: circle, materials: [material])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01  // (масштаб)
        
        return circleEntity
        
    }
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0, color: UIColor = .white, radius: Float = 1) -> Entity {
        // Create share mesh (Сферическая геометрия)
        let sphere = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: false)
        
        // Create sphere entity
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        sphereEntity.position = SIMD3(x, y, z)
        
        return sphereEntity
    }
    
    func makeUIView(context: Context) -> ARView {
        
        // Create AR view
        let arView = ARView(frame: .zero)
        
        // Check that face tracking configuration is supported
        
        guard ARFaceTrackingConfiguration.isSupported else {
            return arView
        }
        
        // Create face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run face tracking session
        arView.session.run(configuration, options: [])
        
        // Create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        // Add box to the face anchor
        faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(createSphere(z: 0.06, radius: 0.025))
        // Add face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
