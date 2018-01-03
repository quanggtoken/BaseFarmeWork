//
//  GTToolKit.swift
//  BaseProject
//
//  Created by quangle on 1/2/18.
//  Copyright © 2018 Gtoken. All rights reserved.
//

import Foundation
import RNCryptor
import SPTPersistentCache
import Kingfisher

final class GTToolKit {
    private init(){
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending(GT_CACHE_PATH)
        let options = SPTPersistentCacheOptions()
        options.cachePath = cachePath!
        options.cacheIdentifier = GT_CACHE_PATH
        options.defaultExpirationPeriod = UInt(GT_CACHE_EXPIRATE_TIME)
        options.garbageCollectionInterval = UInt(1.5)*SPTPersistentCacheDefaultGCIntervalSec
        options.sizeConstraintBytes = UInt(GT_MAXIMUM_CACHE_SIZE)
        options.debugOutput = { output in
            print(output)
        }
        cache = SPTPersistentCache(options: options)
        cache_queue = DispatchQueue(label: GT_CACHE_QUEUE_ID)
        
        image_cache = ImageCache(name: cachePath!)
        image_cache.maxCachePeriodInSecond = TimeInterval(UInt(GT_CACHE_EXPIRATE_TIME))
        
        KingfisherManager.shared.cache = image_cache
    }
    let cache:SPTPersistentCache
    let cache_queue:DispatchQueue
    let image_cache:ImageCache
    static let shareInstance = GTToolKit()
    
    //MARK: Toolkit with String
    
    func isEmail(withData data:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: data)
    }
    
    func isNumber(withData data:String)->Bool {
        let check = "[0-9]"
        let check_number = NSPredicate(format:"SELF MATCHES %@", check)
        return check_number.evaluate(with: data)
    }
    
    func isValidateLength(withData data:String) -> Bool {
        if data.utf8.count >= GT_MINIMUM_STRING_LENGTH && data.utf8.count <= GT_MAXIMUM_STRING_LENGTH {
            return true
        }
        else {
            return false
        }
    }
    
    func keyHashFroContronller(fromName name:String) -> String{
        let key_hash = "\(GT_PREFIX)\(name)"
        var controller_hash = UserDefaults.standard.string(forKey: key_hash)
        if controller_hash != nil {
            return controller_hash!
        }
        else {
            controller_hash = self.randomStringWithLength(length: GT_LENGTH_OF_STRING_KEY)
            UserDefaults.standard.set(controller_hash, forKey: key_hash)
            UserDefaults.standard.synchronize()
            return controller_hash!
        }
    }
    
    func randomStringWithLength (length : Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let time = NSDate().timeIntervalSince1970
        randomString += "\(time)"
        
        return randomString
    }
    
    //MARK: Encrypted and Decrypted data
    
    func encrypted(withData plain_data:Data)->Data{
        return RNCryptor.encrypt(data: plain_data, withPassword: GT_HASH_KEY)
    }
    
    func decrypted(withData cipher_data:Data)->Data?{
        do {
            let plain_data = try RNCryptor.decrypt(data: cipher_data, withPassword: GT_HASH_KEY)
            return plain_data
        }
        catch {
            print(error)
            return nil
        }
    }
    
    //MARK: Save/Load data from Cache
    func saveToCache(withData data:Data, key_hash:String, callback:@escaping(Bool,String)->Void){
        self.cache.store(data, forKey: key_hash, locked: true, withCallback: { (cacheResponse) in
            if cacheResponse.result == .operationSucceeded{
                Dispatch.async(Queue.main, closure: { () -> (Void) in
                    callback(true,"")
                })
            }
            else {
                Dispatch.async(Queue.main, closure: { () -> (Void) in
                    callback(false,cacheResponse.error.localizedDescription)
                })
            }
        }, on: self.cache_queue)
    }
    
    func loadFromCache(withKeyHash key_hash:String, callback:@escaping(Data, Bool)->Void){
        self.cache.loadData(forKey: key_hash, withCallback: { (cacheResponse) in
            if cacheResponse.result == .operationSucceeded{
                Dispatch.async(Queue.main, closure: { () -> (Void) in
                    callback(cacheResponse.record.data,true)
                })
            }
            else {
                Dispatch.async(Queue.main, closure: { () -> (Void) in
                    callback(cacheResponse.record.data,false)
                })
            }
        }, on: Queue.main)
    }
}
