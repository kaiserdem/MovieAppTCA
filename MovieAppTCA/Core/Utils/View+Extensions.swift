import SwiftUI
import UIKit

extension View {
    func customNavigationBar() -> some View {
        self
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                
                // Градієнт для фону
                let gradient = CAGradientLayer()
                gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
                gradient.colors = [
                    UIColor(red: 0.9, green: 0.3, blue: 0.5, alpha: 0.95).cgColor,  // Рожевий
                    UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 0.95).cgColor,   // Помаранчевий
                    UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 0.95).cgColor  // Фіолетовий
                ]
                gradient.locations = [0.0, 0.5, 1.0]
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 0)
                
                UIGraphicsBeginImageContext(gradient.bounds.size)
                if let context = UIGraphicsGetCurrentContext() {
                    gradient.render(in: context)
                    let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    appearance.backgroundImage = backgroundImage
                }
                
                // Налаштування тексту
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 17, weight: .bold)
                ]
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 34, weight: .bold)
                ]
                
                // Налаштування кнопок
                appearance.buttonAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
    
    func customBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.2, green: 0.1, blue: 0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
    }
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        return self
    }
} 