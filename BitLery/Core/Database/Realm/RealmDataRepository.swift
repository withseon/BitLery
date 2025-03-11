//
//  RealmDataRepository.swift
//  BitLery
//
//  Created by 정인선 on 3/10/25.
//

import Foundation
import RealmSwift

protocol RealmRepository {
    func getFileURL()
    func readTable<T: Object>(type: T.Type) -> Results<T>
    func addItem<T: Object>(type: T.Type, item: T) throws
    func deleteItem<T: Object>(type: T.Type, item: T) throws
}

final class RealmDataRepository: RealmRepository {
    static let shared: RealmRepository = RealmDataRepository()
    private init() { }
    
    private var realm: Realm { try! Realm() }
    
    func getFileURL() {
        guard let fileURL = realm.configuration.fileURL else { return }
        print(fileURL)
    }
        
    func readTable<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func addItem<T: Object>(type: T.Type, item: T) throws {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            throw RealmError.save
        }
    }
    
    func deleteItem<T: Object>(type: T.Type, item: T) throws {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            throw RealmError.delete
        }
    }
}
