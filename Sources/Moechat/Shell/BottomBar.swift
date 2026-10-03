import SwiftUI

/// 底栏 —— 四个象限容器装在**一个半透明长容器**里。
/// 点击容器放大，露出子应用网格；两侧容器被挤压让位。再点一次收起。
///
/// 外层长容器的结构与高度照系统 Dock 来：Dock 就是一个半透明长圆角容器装着若干
/// 方形图标。各端取各自系统的值，不强行相等（见 `Theme.barHeight`）。
struct BottomBar: View {
    @Binding var expanded: Quadrant?
    @Binding var activeApp: SubApp?

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // SpaceEvenly：每个容器两侧各占一份等宽的空白，两端也占。
            // 展开态某个容器变宽时，其余空白自动重分 —— 与系统 Dock 一致。
            Spacer(minLength: 0)
            ForEach(Quadrant.allCases) { quadrant in
                QuadrantContainerView(
                    quadrant: quadrant,
                    isExpanded: expanded == quadrant,
                    onTap: { handleTap(quadrant) },
                    onAppTap: { app in
                        activeApp = app
                        expanded = nil
                    }
                )
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.barPadding)
        // 背景只包住长容器本身；外边距在它之外，所以那两层 padding 必须写在后面
        .background(
            Theme.barSurface,
            in: RoundedRectangle(cornerRadius: Theme.barHeight / 2)
        )
        .padding(.horizontal, Theme.shellPadding)
        .padding(.bottom, Theme.barBottom)
        .animation(.spring(response: 0.34, dampingFraction: 0.82), value: expanded)
    }

    /// 点击容器：容器放大，同时默认应用自动进入。再点一次收起。
    private func handleTap(_ quadrant: Quadrant) {
        if expanded == quadrant {
            expanded = nil
        } else {
            expanded = quadrant
            activeApp = quadrant.defaultApp
        }
    }
}
