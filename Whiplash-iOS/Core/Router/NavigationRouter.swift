//
//  NavigationRouter.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case home
    case categoryDetail
    case myPage
    case usePoint
    case history
    case add
}

/// Route와 마찬가지로 케이스 하나당 뷰 하나
enum FullScreenModalDestination: Identifiable {
    case mainTab
    
    var id: String {
        switch self {
        case .mainTab: return "mainTab"
        }
    }
}

enum SheetModalDestination: Identifiable {
    case storeSelectBanner
    
    var id: String {
        switch self {
        case .storeSelectBanner: return "storeSelectBanner"
        }
    }
}

class NavigationRouter: ObservableObject {
    
    /// 현재 네비게이션 스택의 경로를 나타냄.
    @Published var path = NavigationPath()
    @Published var actionFullScreenModal: FullScreenModalDestination? = nil
    @Published var actionSheetModal: SheetModalDestination? = nil
    
    // MARK: - NavigationStack
    
    /// 지정한 route를 스택에 추가하여 화면을 푸시
    func push(_ route: Route) {
        path.append(route)
    }
    
    /// 스택에서 가장 마지막 화면을 제거하여 뒤로 이동
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// 네비게이션 스택을 초기화하여 최상위로 이동
    func reset() {
        path = NavigationPath()
    }
    
    // MARK: - Modal
    
    func fullScreenPresent(_ modal: FullScreenModalDestination) {
        actionFullScreenModal = modal
    }
    
    func sheetPresent(_ modal: SheetModalDestination) {
        actionSheetModal = modal
    }
}

