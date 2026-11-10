import SwiftUI

struct BorderBeamMenu: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        Menu {
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selection)
                Image(systemName: "chevron.down")
                    .imageScale(.small)
            }
            .font(.caption)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.white.opacity(0.07), in: .capsule)
            .frame(minHeight: 44)
        }
        .menuStyle(.button)
        .menuIndicator(.hidden)
        .accessibilityLabel(title)
        .accessibilityValue(selection)
    }
}
