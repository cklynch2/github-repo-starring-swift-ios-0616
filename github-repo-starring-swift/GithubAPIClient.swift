//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "https://api.github.com/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let isStarredRequest = NSMutableURLRequest(URL: unwrappedURL)
        isStarredRequest.addValue(Secrets.githubToken, forHTTPHeaderField: "Authorization")
        isStarredRequest.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(isStarredRequest) { (data, response, error) in
            
            // Is there a way to do this without force casting?
            guard let httpResponse = response as? NSHTTPURLResponse else {
                assertionFailure("Assignment to NSHTTPURLReponse failed.")
                return
            }
            let status = httpResponse.statusCode
            
            var isStarred = Bool()
            if status == 204 {
                isStarred = true
            } else if status == 404 {
                isStarred = false
            } else {
                print("Other status code: \(status)")
            }
            
            completion(isStarred)
        }
        task.resume()
    }
    
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let starRequest = NSMutableURLRequest(URL: unwrappedURL)
        starRequest.addValue(Secrets.githubToken, forHTTPHeaderField: "Authorization")
        
        // Documentation says this is necessary... How do you set it to zero when the input type must be a String?
        starRequest.setValue("0", forHTTPHeaderField: "Content-Length")
        starRequest.HTTPMethod = "PUT"
        
        let task = session.dataTaskWithRequest(starRequest) { (data, response, error) in
            
            let httpResponse = response as! NSHTTPURLResponse
            let status = httpResponse.statusCode
            
            if status == 204 {
                print("Successfully starred this repo.")
            }
            
            completion()
        }
        task.resume()
    }
    
    
    class func unstarRepository(fullName: String, completion: () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let starRequest = NSMutableURLRequest(URL: unwrappedURL)
        starRequest.addValue(Secrets.githubToken, forHTTPHeaderField: "Authorization")
        starRequest.HTTPMethod = "DELETE"
        
        let task = session.dataTaskWithRequest(starRequest) { (data, response, error) in
            
            let httpResponse = response as! NSHTTPURLResponse
            let status = httpResponse.statusCode
            
            if status == 204 {
                print("Successfully unstarred this repo.")
            }
            
            completion()
        }
        task.resume()
    }
    
}

