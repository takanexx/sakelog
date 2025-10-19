//
//  CabinetView.swift
//  SakeLog
//
//  Created by Takane on 2025/10/13.
//
import SwiftUI
import SceneKit

struct CabinetView: View {
    @State private var isShow = false
    @State private var brand: Brand? = nil
    @State private var memoText: String = ""
    @State private var selectedType: String? = nil
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    let types = ["純米", "純米吟醸", "純米大吟醸", "特別純米", "生酒", "吟醸", "大吟醸", "その他"]
    // レイアウト
    let typeColumns = [
        GridItem(.adaptive(minimum: 100), spacing: 10) // 最小幅を指定
    ]

    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<20) { index in
                        ModelRenderView(labelImageName: "izumi", allowsCameraControl: false)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Cabinet")
            .navigationBarTitleDisplayMode(.inline) // タイトルを小さく中央寄せ
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("右上ボタン tapped")
                        isShow.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShow) {
                // ブランドが選択されている場合は詳細表示、そうでなければリスト表示
                if brand != nil {
                    AddBrandSheetView(selectedBrand: $brand, selectedType: $selectedType)
                } else {
                    BrandListView(selectedBrand: $brand)
                }
            }
        }
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var alignment: Alignment = .center
    var spacing: CGFloat?

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            alignment: alignment,
            spacing: spacing
        )
        return result.bounds
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            alignment: alignment,
            spacing: spacing
        )
        for row in result.rows {
            let rowXOffset = (bounds.width - row.frame.width) * alignment.horizontal.percent
            for index in row.range {
                let xPos = rowXOffset + row.frame.minX + row.xOffsets[index - row.range.lowerBound] + bounds.minX
                let rowYAlignment = (row.frame.height - subviews[index].sizeThatFits(.unspecified).height) *
                alignment.vertical.percent
                let yPos = row.frame.minY + rowYAlignment + bounds.minY
                subviews[index].place(at: CGPoint(x: xPos, y: yPos), anchor: .topLeading, proposal: .unspecified)
            }
        }
    }

    struct FlowResult {
        var bounds = CGSize.zero
        var rows = [Row]()

        struct Row {
            var range: Range<Int>
            var xOffsets: [Double]
            var frame: CGRect
        }

        init(in maxPossibleWidth: Double, subviews: Subviews, alignment: Alignment, spacing: CGFloat?) {
            var itemsInRow = 0
            var remainingWidth = maxPossibleWidth.isFinite ? maxPossibleWidth : .greatestFiniteMagnitude
            var rowMinY = 0.0
            var rowHeight = 0.0
            var xOffsets: [Double] = []
            for (index, subview) in zip(subviews.indices, subviews) {
                let idealSize = subview.sizeThatFits(.unspecified)
                if index != 0 && widthInRow(index: index, idealWidth: idealSize.width) > remainingWidth {
                    finalizeRow(index: max(index - 1, 0), idealSize: idealSize)
                }
                addToRow(index: index, idealSize: idealSize)

                if index == subviews.count - 1 {
                    finalizeRow(index: index, idealSize: idealSize)
                }
            }

            func spacingBefore(index: Int) -> Double {
                guard itemsInRow > 0 else { return 0 }
                return spacing ?? subviews[index - 1].spacing.distance(to: subviews[index].spacing, along: .horizontal)
            }

            func widthInRow(index: Int, idealWidth: Double) -> Double {
                idealWidth + spacingBefore(index: index)
            }

            func addToRow(index: Int, idealSize: CGSize) {
                let width = widthInRow(index: index, idealWidth: idealSize.width)

                xOffsets.append(maxPossibleWidth - remainingWidth + spacingBefore(index: index))
                remainingWidth -= width
                rowHeight = max(rowHeight, idealSize.height)
                itemsInRow += 1
            }

            func finalizeRow(index: Int, idealSize: CGSize) {
                let rowWidth = maxPossibleWidth - remainingWidth
                rows.append(
                    Row(
                        range: index - max(itemsInRow - 1, 0) ..< index + 1,
                        xOffsets: xOffsets,
                        frame: CGRect(x: 0, y: rowMinY, width: rowWidth, height: rowHeight)
                    )
                )
                bounds.width = max(bounds.width, rowWidth)
                let ySpacing = spacing ?? ViewSpacing().distance(to: ViewSpacing(), along: .vertical)
                bounds.height += rowHeight + (rows.count > 1 ? ySpacing : 0)
                rowMinY += rowHeight + ySpacing
                itemsInRow = 0
                rowHeight = 0
                xOffsets.removeAll()
                remainingWidth = maxPossibleWidth
            }
        }
    }
}

private extension HorizontalAlignment {
    var percent: Double {
        switch self {
        case .leading: return 0
        case .trailing: return 1
        default: return 0.5
        }
    }
}

private extension VerticalAlignment {
    var percent: Double {
        switch self {
        case .top: return 0
        case .bottom: return 1
        default: return 0.5
        }
    }
}


#Preview {
    CabinetView()
}
