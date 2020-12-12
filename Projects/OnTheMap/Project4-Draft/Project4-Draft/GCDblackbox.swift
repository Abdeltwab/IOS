//
//  GCDblackbox.swift
//  Project4-Draft
//
//  Created by Abdeltwab Elhussin on 3/16/19.
//  Copyright © 2019 Abdeltwab Elhussin. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    
    DispatchQueue.main.async { updates() }
}
