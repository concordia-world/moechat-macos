import SwiftUI

/// moechat 的统一视觉语言。
/// 五个原生宿主（macOS / Windows / Linux / iOS / Android）各自实现，但共用这一套取值。
enum Theme {
    static let background = Color(hex: 0x0A0B0D)

    static let surface = Color.white.opacity(0.055)
    static let surfaceStroke = Color.white.opacity(0.10)
    static let raised = Color.white.opacity(0.07)

    /// 底栏外层那个半透明长容器的底。比容器自身的 surface 亮一档 ——
    /// 两者是叠起来的（长容器 ← 象限容器），不拉开就分不出层次。
    static let barSurface = Color.white.opacity(0.09)

    static let primaryText = Color.white.opacity(0.92)
    static let secondaryText = Color.white.opacity(0.66)
    static let tertiaryText = Color.white.opacity(0.42)
    static let faintText = Color.white.opacity(0.28)

    static let addressBar = Color.white.opacity(0.06)
    static let addressText = Color.white.opacity(0.80)

    static let radiusContainer: CGFloat = 16
    static let radiusGridCell: CGFloat = 18

    static let shellPadding: CGFloat = 14

    // ── 主体容器：一个半透明长条，四个象限容器装在里面 ──
    //
    // 结构与高度都照系统 Dock 来。macOS 的 Dock 图标尺寸是 64（`defaults read
    // com.apple.dock tilesize`），加上下各 11 的内边距就是 86 —— 与从截图量到的
    // Dock 高度一致。**各端取各自系统的值，不强行相等**：Android 侧取的是
    // 华为 Mate X5 底栏的 74dp。两边贴各自系统的观感，而不是互相看齐。
    static let barHeight: CGFloat = 86
    static let barPadding: CGFloat = 11
    static let barBottom: CGFloat = 6

    /// 主体容器的圆角。**不是胶囊**（不是高度的一半）——
    /// macOS Dock 实测圆角约 25pt，占其 86pt 高度的 **29%**；
    /// X5 底栏量出来也是 30%，两边一致在这个比例上。
    static let radiusBar: CGFloat = 26

    /// 收起态容器：**方形**，边长 = barHeight − 2×barPadding = 64，正好等于 Dock 的 tilesize。
    static let collapsedSize: CGFloat = barHeight - barPadding * 2

    /// 收起态四个象限容器的间距。macOS Dock 实测**稳定在 16pt**（图标可见宽约 52pt，
    /// tilesize 是 64 —— 图标素材自带透明边距，所以可见的比 tile 小）。
    /// Android 侧取的是 24dp，那边系统底栏的间距明显更大。
    static let containerGap: CGFloat = 16
    static let collapsedPadding: CGFloat = 6
    static let thumbCell: CGFloat = 20
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
