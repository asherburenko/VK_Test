//
//  AppError.swift
//  VK_Test
//
//  Created by Александр Шербуренко on 14.06.2022.
//

import Foundation

enum AppError: Error {
    case noDataProvided
    case failedToDecode
    case errorTask
    case notCorrectUrl
}
