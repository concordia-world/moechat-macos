# Resources

## AppIcon.icns

宿主 app 图标。**源图不在本仓库**，在
[`moechat-spec`](https://github.com/concordia-world/moechat-spec) 的 `brand/logo/icon/`。

重新生成：

```sh
# 1. 从 moechat-spec 的 icon-*.png 造一个 .iconset
#    （16/32/64 从最近的更大源降采样，绝不放大）
# 2. iconutil -c icns AppIcon.iconset -o AppIcon.icns
```

**没有 512@2x（1024px）那一档**：源图原生上限是 552px，1024 只能靠插值放大，
与其塞一张糊的进去，不如缺这一档——macOS 会用 512 顶上。

`scripts/make-app.sh` 会把它拷进 `Contents/Resources/`，
并在 `Info.plist` 里写 `CFBundleIconFile`。
