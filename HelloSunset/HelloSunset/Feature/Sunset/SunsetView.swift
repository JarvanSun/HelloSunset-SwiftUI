//
//  SunsetView.swift
//  HelloSunset
//
//  Created by JarvanSun on 2022/5/25.
//

import SwiftUI

struct SunsetView: View {

    var body: some View {
        VStack {
            Text("Hello Sunset")
        }
    }
}


#if DEBUG
struct SunsetView_Previews: PreviewProvider {
    static var previews: some View {
        SunsetView()
            .environment(\.locale, Locale(identifier: "fr"))
    }
}
#endif
