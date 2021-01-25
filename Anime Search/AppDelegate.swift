//
//  AppDelegate.swift
//  Anime Search
//
//  Created by 林祐辰 on 2020/12/30.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 //       PersistentManager.shared.fetchSavedData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
      
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AnimeSearchData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

}

extension NSPersistentContainer {
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func checkIfExists<T: NSManagedObject>(_ objectType: T.Type, identity: Float) {
    
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identity == 0",identity)
        
        do {
           let needDeleteResults = try (self.viewContext.fetch(fetchRequest) as? [T])
            if let needDeleteResults = needDeleteResults{
              for deleteresult in needDeleteResults{
                viewContext.delete(deleteresult)
              }
            }
        } catch {
            print(error)
        }
        
    }
    
    
    func checkIfDuplicate<T: NSManagedObject>(_ objectType: T.Type,identity: Float) {
        let context = self.viewContext
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identity == %f",identity)
        
        var results: [T] = []
        
        do {
            results = try (context.fetch(fetchRequest) as? [T] ?? [])
        } catch {
            print(error)
        }
        
        print(results.count)
        
        if results.count > 1{
            viewContext.delete(results[1])
        }
       }
    
    
    
    
    func delete<T: NSManagedObject>(_ objectType: T.Type, identity: Float) {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identity == %f", identity)
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try self.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            
            if let results = results , results.count > 0 {
                for result in results{
                        viewContext.delete(result)
                         do {
                            try viewContext.save()
                            print("Deleted successfully")
                         } catch {
                            print(error)
                         }
                    }
            
                
            }
        } catch {
            print(error)
        }
    }
}
