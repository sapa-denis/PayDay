//
//  UITableView+Updates.swift
//  PayDay
//
//  Created by Sapa Denys on 14.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

extension UITableView: CollectionContentUpdating {

    func perform(updates: [ContentUpdate]) {
        updates.forEach {
            switch $0.type {
            case .insert:
                perform(insert: $0)
            case .delete:
                perform(delete: $0)
            case .move:
                perform(move: $0)
            case .update:
                perform(update: $0)
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Private methods
private extension UITableView {

    func perform(insert: ContentUpdate) {
         guard let indexPath = insert.newIndexPath else {
             return
         }

          insertRows(at: [indexPath], with: .left)
     }

    func perform(delete: ContentUpdate) {
         guard let indexPath = delete.atIndexPath else {
             return
         }

          deleteRows(at: [indexPath], with: .left)
     }

    func perform(move: ContentUpdate) {
        guard let indexPath = move.atIndexPath,
            let toIndexPath = move.newIndexPath else {
                return
        }

         moveRow(at: indexPath, to: toIndexPath)
    }

    func perform(update: ContentUpdate) {
        guard let indexPath = update.atIndexPath else {
            return
        }
        reloadRows(at: [indexPath], with: .none)
    }

}
