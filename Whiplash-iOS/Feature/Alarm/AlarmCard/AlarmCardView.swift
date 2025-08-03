//
//  AlarmCardView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import SwiftUI
import ComposableArchitecture

struct AlarmCardView: View {
    @Bindable var store: StoreOf<AlarmCardFeature>
    
    init(store: StoreOf<AlarmCardFeature>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            
            Color.gray900
            VStack(spacing: 24) {
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        AppText(text: store.alarm.title, style: .subtitle6_b_14, color: .gray300)
                        Spacer()
                    }
                    HStack {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                AppText(text: store.alarm.morningNight, style: .subtitle2_m_20, color: .white)
                                AppText(text: store.alarm.time, style: .number1_b_28, color: .white)
                                Spacer()
                            }
                            HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                    Image(.Image.icWeek16)
                                    AppText(text: store.alarm.repeatDays, style: .body5_m_11, color: .gray500)
                                }
                                HStack(spacing: 2) {
                                    Image(.Image.icMapPinGray16)
                                    AppText(text: store.alarm.address, style: .body5_m_11, color: .gray500)
                                }
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        Toggle(isOn: $store.alarm.isToggleOn.sending(\.bindingToggle)) {
                            
                        }
                        .toggleStyle(AppToggleStyle())
                    }
                    
                }
                
                AppButton(title: "도착 인증!",
                           size: .h44,
                           type: .black,
                           state: .normal) {
                    
                }
                
                Rectangle()
                    .foregroundStyle(Color.gray700)
                    .frame(height: 1)
            }
        }
        .frame(height: 147)
    }
}

#Preview {
    AlarmCardView(store: Store(initialState: AlarmCardFeature.State(),
                           reducer: { AlarmCardFeature() })
    )
}
