//
//  HMDAAmazonS3.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 19/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import Foundation

import S3
import NIOTransportServices
import NIO

public typealias S3Handler = (Result<Any, Error>) -> Void
public typealias S3ProgressHandler = (Double) -> Void

public struct HMDAAmazonS3 {
    public var s3: S3
    public var eventLoopGroup: NIOTSEventLoopGroup
    public var bucketID: String
    
    public init(withAccessKey accessKey: String, andSecretKey secretKey: String, andBucketID bucketID: String) {
        eventLoopGroup = NIOTSEventLoopGroup(loopCount: 10, defaultQoS: .background)
        
        self.bucketID = bucketID
        
        s3 = S3(accessKeyId: accessKey,
                secretAccessKey: secretKey,
                sessionToken: nil,
                region: .eucentral1,
                endpoint: nil,
                middlewares: [],
                eventLoopGroupProvider: .shared(eventLoopGroup))
    }
    
    public var eventLoop: EventLoop? {
        s3.client.eventLoopGroup.next()
    }
    
    static public func getFiles(s3config: HMDAAmazonS3, completionHandler: @escaping S3Handler) {
        
        let future = s3config.s3.listObjects(S3.ListObjectsRequest(bucket: s3config.bucketID))
        
        future.whenComplete { (result) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let output):
                    DispatchQueue.main.async {
                        completionHandler(.success(output))
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                    
                }
                
            }
        }
        
    }
    
    static public func downloadFile(s3config: HMDAAmazonS3,
                             fileKey: String,
                             downloadPath: String,
                             progressHandler: @escaping S3ProgressHandler,
                             completionHandler: @escaping S3Handler) {
        
        let future = s3config.s3.multipartDownload(S3.GetObjectRequest(bucket: s3config.bucketID, key: fileKey),
                                                   partSize: 327680,
                                                   filename: downloadPath,
                                                   on: s3config.eventLoop,
                                                   progress: { (progress) in
                                                    
                                                    DispatchQueue.main.async {
                                                        progressHandler(progress)
                                                    }
                                                    
                                                    
        })
        
        future.whenComplete { (result) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let fileSize):
                    completionHandler(.success(fileSize))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
                
            }
        }
        
        
    }
    
    static public func getObject(s3config: HMDAAmazonS3,
                          fileKey: String,
                          completionHandler: @escaping S3Handler) {
        
        let future = s3config.s3.getObject(S3.GetObjectRequest(bucket: s3config.bucketID, key: fileKey))
        
        future.whenComplete { (result) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                case .success(let output):
                    completionHandler(.success(output))
                    
                }
                
            }
        }
        
    }
    
    static public func listBuckets(s3config: HMDAAmazonS3, completionHandler: @escaping S3Handler) {
        
        let future = s3config.s3.listBuckets()
        
        future.whenComplete { (result) in
            
            DispatchQueue.main.async {
            
                switch result {
                    
                case .success(let output):
                    completionHandler(.success(output))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                }
                
            }
            
            
        }
        
    }

    static public func deleteFile(s3config: HMDAAmazonS3,
                           fileKey: String,
                           completionHandler: @escaping S3Handler) {
        
        let future = s3config.s3.deleteObject(S3.DeleteObjectRequest(bucket: s3config.bucketID, key: fileKey))
        
        future.whenComplete { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let output):
                    completionHandler(.success(output))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
    static public func deleteFiles(s3config: HMDAAmazonS3,
                            fileKeys: [String],
                            completionHandler: @escaping S3Handler) {

        let deletionIDs = fileKeys.map { (fileKey) -> S3.ObjectIdentifier in
            S3.ObjectIdentifier(key: fileKey)
        }
        
        let deletionCompound = S3.Delete(objects: deletionIDs)
        
        let future = s3config.s3.deleteObjects(S3.DeleteObjectsRequest(bucket: s3config.bucketID, delete: deletionCompound))
        
        future.whenComplete { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let output):
                    completionHandler(.success(output))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                    
                }
                
            }
            
        }
        
    }
    
}

