//
//  ViewModel.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
