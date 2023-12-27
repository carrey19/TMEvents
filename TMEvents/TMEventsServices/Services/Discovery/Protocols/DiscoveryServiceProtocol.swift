//
//  DiscoveryServiceProtocol.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import Foundation

protocol DiscoveryServiceProtocol {
    func searchEventsBy(keyword: String, completion: @escaping DiscoveryResponse)
}
