//
//  PostManager.swift
//  iOSApp
//
//  Created by Erin Dieringer on 12/1/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation

class PostManager {
    
    func postTag(tag: Tag) {
        let string = "https://reminderappapi.herokuapp.com/tags"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "tag":[ "name":tag.name! ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
    }
    
    func postFriend(friend: Friend) {
        let string = "https://reminderappapi.herokuapp.com/friends"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "friend":[ "phone_number":friend.phoneNumber!, "first_name":friend.firstName!, "last_name":friend.lastName!]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
        
    }
    func postLocationTag(location: String, tag: String) {
        let string = "https://reminderappapi.herokuapp.com/location_tags"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "location_tag":[ "location":location, "tag":tag ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
    }
    
    func postLocation(loc: Location) {
        let string = "https://reminderappapi.herokuapp.com/locations"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "location":[ "latitude":loc.latitude!, "longitude":loc.longitude!, "name":loc.name!, "phone":loc.phone!, "address":loc.address!, "placemark":loc.placemark! ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
    }
    
    func postReminderFriend(reminder_list: String, friend: String) {
        let string = "https://reminderappapi.herokuapp.com/reminder_friends"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "reminder_friend":[ "reminder_list":reminder_list, "friend":friend  ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
        
    }
    
    func postList(list: List) {
        let string = "https://reminderappapi.herokuapp.com/reminder_lists"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "reminder_list":[ "name":list.name!, "date_created":list.dateCreated!, "date_modified":list.dateModified!, "shared":list.shared!, "user":list.user!.phoneNumber! ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
        
    }
    
    func postReminderTag(tag: String, reminder_list: String) {
        let string = "https://reminderappapi.herokuapp.com/reminder_tags"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "reminder_tag":[ "tag":tag, "reminder_list":reminder_list  ]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
    }
    
    func postItem(item: Item) {
        let string = "https://reminderappapi.herokuapp.com/reminders"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "reminder":[ "text":item.text!, "reminder_list":item.list!.name!]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
        
    }
    
    func postUser(user: User) {
        let string = "https://reminderappapi.herokuapp.com/users"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "user":["first_name":user.firstName!, "last_name":user.lastName!, "phone_number":user.phoneNumber!]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()
        
    }
    
    func postLocationItem(name: String, latitude: Double, longitude: Double) {
        let string = "https://reminderappapi.herokuapp.com/locations"
        let url = NSURL(string: string)!
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        let params = [ "location":["name":name, "latitude":latitude, "longitude":longitude]]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            print(request)
        }
        catch {
            
        }
        let tache = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let antwort = response as? NSHTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
        }
        tache.resume()

    
    }
    
    func getLocations() -> NSArray {
        let string = "https://reminderappapi.herokuapp.com/locations"
        let url = NSURL(string: string)!
        let request = NSMutableURLRequest(URL: url)
        var items: NSArray =  []
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            do{
                items = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
               
            }
            catch {
                print("json error: \(error)")
            }
        }
        
        task.resume()
        return items
    
        
    }
    
    
    
    
}
