import SwiftUI

/// **主体容器** —— 装主体四个象限的那个半透明长条，四个象限容器在里面。
///
/// 名字的由来：第 1-2-3-4 象限本来就是**主体的**象限。
///
/// 点击容器放大，露出子应用网格；其余容器让位。再点一次收起。
/// 结构与高度照系统 Dock 来：Dock 就是一个半透明长圆角容器装着若干方形图标。
/// 各端取各自系统的值，不强行相等（见 `Theme.barHeight`）。
struct BottomBar: View {
    @Binding var expanded: Quadrant?
    @Binding var activeApp: SubApp?

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.containerGap) {
            ForEach(Quadrant.allCases) { quadrant in
                container(quadrant)
            }
        }
        // **主体容器贴内容**：收起和展开**同一套排布法则** ——
        // 它跟着内容变长（宽）变宽（高）。
        //
        // 另外两条路都试过，各自坏一处：
        //   撑满父级 → 收起时四个容器挤在中间、两端空一大片
        //   高度固定 → 展开的容器从长条上「长出来」，比例突兀
        .padding(Theme.barPadding)
        .background(
            Theme.barSurface,
            // 圆角取**当前高度的 30%**，不是固定值 ——
            // 容器变高时比例才不会掉（固定 26pt 到 122 高就只剩 21%）。
            in: RoundedRectangle(cornerRadius: pillRadius)
        )
        // 主体容器在可用宽度里居中；它自己不撑满，所以这里要有一层来托
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, Theme.shellPadding)
        .padding(.bottom, Theme.barBottom)
        .animation(.spring(response: 0.34, dampingFraction: 0.82), value: expanded)
    }

    /// 容器内容的高度：收起态是方形边长，展开态由格子数算出。
    private var contentHeight: CGFloat {
        guard let quadrant = expanded else { return Theme.collapsedSize }
        return Theme.expandedHeight(rows: quadrant.gridRows)
    }

    /// 主体容器的圆角 = 当前高度的 30%。容器一变高，比例跟着走。
    private var pillRadius: CGFloat {
        (contentHeight + Theme.barPadding * 2) * Theme.radiusBarRatio
    }

    private func container(_ quadrant: Quadrant) -> some View {
        QuadrantContainerView(
            quadrant: quadrant,
            isExpanded: expanded == quadrant,
            onTap: { handleTap(quadrant) },
            onAppTap: { app in
                activeApp = app
                expanded = nil
            }
        )
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
