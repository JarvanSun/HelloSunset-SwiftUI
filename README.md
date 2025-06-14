# HelloSunset-SwiftUI

一个基于SwiftUI开发的日落时间应用，根据用户当前位置计算并显示今日日落时间及倒计时。

## 功能特性

- 🌅 实时显示当日日落时间
- 📍 基于GPS定位自动获取用户位置
- ⏰ 日落倒计时显示
- 🌙 支持明暗主题切换
- 🎨 渐变背景设计，营造日落氛围

## 技术架构

### 核心组件
- **SunsetView**: 主界面视图，展示日落时间和倒计时
- **SunsetViewModel**: 视图模型，管理状态和业务逻辑
- **SuntimeManager**: 日出日落时间计算管理器
- **LocationManager**: 位置服务管理器

### 依赖注入
- **SunsetDependencyResolver**: 依赖解析器，提供解耦的架构设计

### 第三方库
- **Solar**: 用于精确计算日出日落时间的天文计算库
- **CoreLocation**: 系统位置服务
- **Combine**: 响应式编程框架

## 项目结构

```
HalloSunset/
├── Core/                    # 核心业务逻辑
│   ├── DateTools.swift      # 日期工具类
│   ├── LocationManager.swift # 位置管理器实现
│   ├── LocationManaging.swift # 位置管理协议
│   ├── SuntimeManager.swift  # 日出日落计算实现
│   └── SuntimeManaging.swift # 日出日落计算协议
├── Feature/
│   └── Sunset/              # 日落功能模块
│       ├── SunsetView.swift # 主视图
│       ├── SunsetViewModel.swift # 视图模型
│       └── SunsetDependency* # 依赖注入相关
└── HalloSunsetApp.swift     # 应用入口
```

## 运行要求

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## 权限要求

- 位置访问权限（使用期间）

## 安装运行

1. 克隆项目到本地
2. 使用Xcode打开 `HalloSunset.xcodeproj`
3. 运行项目到模拟器或真机设备

## 作者

Created by Jiawen Sun
