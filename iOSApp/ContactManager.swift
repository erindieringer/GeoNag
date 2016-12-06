//
//  ContactManager.swift
//  iOSApp
//
//  Created by Erin Dieringer on 12/1/16.
//  Copyright © 2016 Katie Williams. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager: NSObject {
   
    static let sharedManager = ContactsManager()
    private let contactStore: CNContactStore!
    
    override init() {
        contactStore = CNContactStore()
        super.init()
    }
    
    //Request for contact access
    func requestAutorizationForContactsAddressBook(completion: (granted: Bool, e: NSError?) -> Void) {
        contactStore.requestAccessForEntityType(.Contacts) { (granted, e) -> Void in
            completion(granted: granted, e: e)
        }
    }
    
    //Request contact fetch
    func fetchValidAddressBookContacts(completion: (contacts: [CNContact]?, e: NSError?) -> Void) {
        
        do {
            var validContacts: [CNContact] = []
            // Specify the key fields that you want to be fetched.
            // Note: if you didn't specify your specific field request. your app will crash
            let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactThumbnailImageDataKey])
            
            try contactStore.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (contact, error) -> Void in
                
                // Lets filter (optional)
                if !contact.emailAddresses.isEmpty || !contact.phoneNumbers.isEmpty {
                    validContacts.append(contact)
                }
            })
            // throws contacts on completion handler
            completion(contacts: validContacts, e: nil)
        }catch let e as NSError {
            completion(contacts: nil, e: e)
        }
    }
}
