

import SwiftUI
import CoreData


@main
struct DagensLatterApp: App {
    let persistenceController = PersistenceController.shared
    @State var isSplashScreenShowing = true
    @ObservedObject var storedJokesCounter = StoredJokeCounter()
    @AppStorage("isDarkMode") var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            if isSplashScreenShowing {
                SplashScreenView(isFinished: $isSplashScreenShowing)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isSplashScreenShowing = false
                            }
                        }
                    }
            } else {
                TabView {
                    HomeScreen(demoJoke: demoJoke)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    UnratedJokesView(demo: demoJoke)
                        .tabItem {
                            Label("Unrated Jokes", systemImage: "theatermasks.fill")
                        }
                        .badge(storedJokesCounter.unratedJokesStored)
                    RatedJokesView()
                        .tabItem {
                            Label("Rated Jokes", systemImage: "star.circle.fill")
                        }
                        .badge(storedJokesCounter.ratedJokesStored)
                    SelfMadeJokeView()
                        .tabItem {
                            Label("My Jokes", systemImage: "person.circle.fill")
                        }
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(storedJokesCounter)
                .onAppear {
                    getDocumentsDirectory()
                    print("App launched. Dark mode is \(isDarkMode ? "ON" : "OFF")")
                }
            }
        }
        
    }
    
    func getDocumentsDirectory() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // Navigate one directory up from the Documents directory
        let parentDirectory = documentsDirectory.deletingLastPathComponent()
        print("Directory: \(parentDirectory)")
    }
}
