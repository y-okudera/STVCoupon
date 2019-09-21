//
//  RealmDaoHelper.swift
//  SharedRealmDemoApp
//
//  Created by Yuki Okudera on 2019/08/17.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDaoHelper <T: RealmSwift.Object>: ExceptionCatchable {

    // MARK: - Create a new primary key

    /// 新規主キー発行
    func newId() -> Int? {
        guard let primaryKey = T.primaryKey() else {
            print("primaryKey未設定")
            return nil
        }
        let realm = Realm.sharedRealm()
        if let maxValue = realm.objects(T.self).max(ofProperty: primaryKey) as Int? {
            return maxValue + 1
        } else {
            return 1
        }
    }

    // MARK: - Add record

    /// レコード追加
    func add(d: T) throws {
        let realm = Realm.sharedRealm()

        let executionError = executionBlock(realm: realm) {
            realm.add(d)
        }

        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }
    
    /// レコード追加(複数)
    func add(objects: [T]) throws {
        let realm = Realm.sharedRealm()
        
        let executionError = executionBlock(realm: realm) {
            realm.add(objects)
        }
        
        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }

    // MARK: - Update record

    /// T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
    func update(d: T, block:(() -> Void)? = nil) throws {
        let realm = Realm.sharedRealm()

        let executionError = executionBlock(realm: realm) {
            block?()
            realm.add(d, update: .modified)
        }

        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }

    // MARK: - Delete records

    /// レコード全削除
    func deleteAll() throws {
        let realm = Realm.sharedRealm()
        let objs = realm.objects(T.self)

        let executionError = executionBlock(realm: realm) {
            realm.delete(objs)
        }

        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }

    /// レコード削除
    func delete(d: T) throws {
        let realm = Realm.sharedRealm()

        let executionError = executionBlock(realm: realm) {
            realm.delete(d)
        }

        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }
    
    /// レコード削除(複数)
    func delete(objects: Results<T>) throws {
        let realm = Realm.sharedRealm()
        
        let executionError = executionBlock(realm: realm) {
            realm.delete(objects)
        }
        
        // エラーがある場合throw
        if let executionError = executionError {
            throw executionError
        }
    }

    // MARK: - Find records

    /// 全件取得（Results<T> type）
    func findAll() -> Results<T> {
        let realm = Realm.sharedRealm()
        return realm.objects(T.self)
    }

    /// 全件取得（Array type）
    func findAllConvertedToArray() -> [T] {
        return Array(findAll())
    }

    /// 指定キーのレコードを取得
    func findById(id: Any) -> T? {
        let realm = Realm.sharedRealm()
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    /// 指定キーのレコードを取得(複数)
    func findByIds(ids: [Any]) -> Results<T>? {
        guard let pk = T.primaryKey() else {
            return nil
        }
        let predicate = NSPredicate(format: "\(pk) IN %@", ids)
        let realm = Realm.sharedRealm()
        let results = realm.objects(T.self).filter(predicate)
        return results
    }
}

// MARK: - static
extension RealmDaoHelper {

    static func transaction(block:(() throws -> Void)? = nil) throws {
        let realm = Realm.sharedRealm()
        realm.beginWrite()
        do {
            try block?()
            try realm.commitWrite()
        } catch {
            print("transaction", error, "realm.cancelWrite()")
            realm.cancelWrite()
            throw error
        }
    }
}

// MARK: - private
private extension RealmDaoHelper {

    func executionBlock(realm: Realm, block:(() -> Void)? = nil) -> Swift.Error? {
        // WriteTransaction外の場合は、outsideOfTransactionBlockを実行する
        if !realm.isInWriteTransaction {
            return outsideOfTransactionBlock(realm: realm, block: block)
        }

        do {
            try execute {
                block?()
            }
            return nil

        } catch {
            print("executionBlock error:", error)
            return error
        }
    }

    func outsideOfTransactionBlock(realm: Realm, block:(() -> Void)? = nil) -> Swift.Error? {
        do {
            try realm.write {
                try execute {
                    block?()
                }
            }
            return nil

        } catch {
            print("outsideOfTransactionBlock error:", error)
            return error
        }
    }
}
