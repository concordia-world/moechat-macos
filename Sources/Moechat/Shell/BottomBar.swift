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
        Group {
            if expanded == nil {
                // 收起：容器之间固定间距 —— 主体容器的宽度由**内容**决定，
                // 不撑满父级（这正是「宽度不必是父界面的 100%」的落点）
                HStack(alignment: .center, spacing: Theme.containerGap) {
                    containers
                }
            } else {
                // 展开：撑满 + 均分。格子宽了需要空间，也顺势把其余容器挤开。
                HStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    ForEach(Quadrant.allCases) { quadrant in
                        container(quadrant)
                        Spacer(minLength: 0)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(Theme.barPadding)
        // 背景只包住长容器本身；外边距在它之外，所以那两层 padding 必须写在后面
        .background(
            Theme.barSurface,
            in: RoundedRectangle(cornerRadius: Theme.radiusBar)
        )
        // 主体容器在可用宽度里居中；它自己不撑满，所以这里要有一层来托
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, Theme.shellPadding)
        .padding(.bottom, Theme.barBottom)
        .animation(.spring(response: 0.34, dampingFraction: 0.82), value: expanded)
    }

    /// 收起态：四个容器按固定顺序排（间距由外面的 HStack 给）。
    private var containers: some View {
        ForEach(Quadrant.allCases) { quadrant in
            container(quadrant)
        }
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
