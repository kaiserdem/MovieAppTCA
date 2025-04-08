import SwiftUI
import ComposableArchitecture
import UIKit

struct MainTabView: View {
    var body: some View {
        TabView {
            MovieListView(
                store: Store(
                    initialState: MovieListFeature.State(),
                    reducer: { MovieListFeature() }
                )
            )
            .tabItem {
                Image(systemName: "film.stack")
                Text("Categories")
            }
            
            Text("Genres")
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Genres")
                }
            
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            // Градієнт
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
            gradient.colors = [
                UIColor(red: 0.9, green: 0.3, blue: 0.5, alpha: 0.95).cgColor,  // Рожевий
                UIColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 0.95).cgColor,   // Помаранчевий
                UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 0.95).cgColor  // Фіолетовий
            ]
            gradient.locations = [0.0, 0.5, 1.0]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            
            // Конвертуємо градієнт в зображення
            UIGraphicsBeginImageContext(gradient.bounds.size)
            if let context = UIGraphicsGetCurrentContext() {
                gradient.render(in: context)
                let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                appearance.backgroundImage = backgroundImage
            }
            
            // Неактивні вкладки - білий напівпрозорий
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.7)
            
            // Активна вкладка - чорний
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.black
            ]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
} 