

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimatingLogo = false
    
    @Binding var isFinished: Bool  
    
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.1
    
    var body: some View {
        ZStack {
             Image("scene")
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                 .edgesIgnoringSafeArea(.all)
           Image("comedy-logo")
               .resizable()
               .scaledToFit()
               .frame(width: 300, height: 300)
               .rotationEffect(Angle(degrees: rotation))
               .opacity(opacity)
               .scaleEffect(scale)
         }
         .onAppear {
             withAnimation {
                 rotation = 360
                 opacity = 1
                 scale = 1
             }
         }
    }
}
