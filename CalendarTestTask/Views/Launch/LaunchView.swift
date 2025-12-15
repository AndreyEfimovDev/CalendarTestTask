//
//  LaunchView.swift
//  StartToSwiftUI
//
//  Created by Andrey Efimov on 27.10.2025.
// #2A5FB4 #3765AF

import SwiftUI
internal import Combine

struct LaunchView: View {
    
    let completion: () -> ()
    
    @State private var showLoadingProgress: Bool = false
    @State private var counter: Int = 0
    @State private var loadingString: [String] = "............. загрузка ............".map { String($0) }
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    private var yOffsetValue: CGFloat {
        if isiPhoneSE3rdGeneration() {
            return -10
        } else {
            return -12
        }
    }

    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("A_1024x1024_text")
                .resizable()
                .font(.headline)
                .fontWeight(.heavy)
                .frame(width: 200, height: 200)
                .offset(y: yOffsetValue)
            
            ZStack {
                if showLoadingProgress {
                    HStack(spacing: 0) {
                        ForEach(loadingString.indices, id: \.self) { index in
                            Text(loadingString[index])
                                .offset(y: counter == index ? -11 : 0)
                        } 
                    }
                    .font(.subheadline)
                    .transition(.scale.animation(.easeIn))
                }
            }
            .offset(y: 135)
        }
        .foregroundColor(Color.launch.accent)
        .onAppear {
            showLoadingProgress.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation() {
                let lastIndex = loadingString.count - 1
                if counter == lastIndex {
                        completion()
                } else {
                    counter += 1
                }
            }
        }
    }
    
    
    private func isiPhoneSE3rdGeneration() -> Bool {
#if targetEnvironment(simulator)
        // По размеру экрана (в симуляторе)
        let screenSize = UIScreen.main.bounds.size
        let isSmallScreen = screenSize.width == 375 && screenSize.height == 667 // iPhone SE 3rd gen resolution
        return isSmallScreen
        
#else
        // Для реального устройства
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        // iPhone SE 3rd generation идентификаторы
        return identifier == "iPhone14,6"
#endif
    }

}
#Preview {
    LaunchView() {}
}

//
//private var yOffsetValue: CGFloat {
//        let screenHeight = UIScreen.main.bounds.height
//        
//        // По высоте экрана
//        switch screenHeight {
//        case 667: // iPhone SE 3rd gen, iPhone 8, iPhone 7, iPhone 6s
//            return 80
//        case 736: // iPhone 8 Plus, iPhone 7 Plus, iPhone 6s Plus
//            return 60
//        case 812: // iPhone X, XS, 11 Pro, 12 mini, 13 mini
//            return 40
//        case 844: // iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro
//            return 20
//        case 852: // iPhone 14, iPhone 14 Pro
//            return 10
//        case 896: // iPhone XR, iPhone XS Max, iPhone 11, iPhone 11 Pro Max
//            return 0
//        case 926: // iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus
//            return -10
//        case 932: // iPhone 14 Pro Max
//            return -20
//        default:
//            return -30
//        }
//    }
