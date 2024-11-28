<!--
 * @Author: XQ
 * @Date: 2024-11-19 10:37:22
 * @LastEditTime: 2024-11-28 10:39:52
 * @LastEditors: XQ
 * @Description: 
 * @FilePath: \undefinedd:\xuqiang\github\Kanzi-Demos\readme.md
-->
# 介绍
本仓库主要是前期学习Kanzi技术的一个过程记录

# 仓库介绍和说明
## Getting Started
在本仓库的这一步中主要学习：  
- 熟悉Kanzi里面的一些简单流程
- 按钮 
- 状态切换 
- 属性控制 
- 资源加载 

<img src="./res/getting-started-completed.gif" alt="效果图" width="850" height="550">

## First Application
在本仓库的这一步中主要学习：  
- 属性
- Kanzi状态切换 
- Trajectory List Box使用 
- 效卡片制作 
- 布局  
![效果图](./res/First%20Application.gif)  
## Activity
在本仓库的这一步中主要学习：

- 关于不同类型的Activity节点

- 如何使用活动浏览器创建具有活动节点的应用程序结构

- 如何使用状态管理器控制活动节点的激活状态

<img src="./res/ab-left-area.gif" alt="效果图" width="850" height="550">

## Data Triger
在本仓库的这一步中主要学习：
- 如何使用条件来控制应用程序 UI
- 如何通过创建弹出窗口来控制组成 UI 的活动的激活状态，应用程序仅在满足数据触发器中的条件时才会显示这些弹出窗口
- 绑定表达式的形式在数据触发器中设置条件

<img src="./res/dt-complete.gif" alt="效果图" width="850" height="550">

## Components  
在本仓库的这一步中主要学习自定义控件：
- Toggle Button  

<img src="./res/toggle-button-final.gif" alt="效果图" width="650" height="350">

- Button  

<img src="./res/button-states.gif" alt="效果图" width="650" height="350">

- Slider

<img src="./res/slider-value-indicator.gif" alt="效果图" width="650" height="350">

- List Box

<img src="./res/list-box.gif" alt="效果图" width="650" height="350">

## Data Source
在本仓库的这一步中主要学习应用程序使用数据源插件：
- 数据源将用户界面与应用程序数据分离
- 通过定义 Kanzi Engine 数据源插件来定义数据源的格式和结构
- 定义 XML 数据源以及如何在 Kanzi Studio 项目中使用该数据源中的数据向 Kanzi 应用程序提供数据

<img src="./res/end-of-step-3.png" alt="效果图" width="850" height="350">

## Data-Driven Activities
在本仓库的这一步中主要学习使用数据驱动来显示Activity：
- 数据驱动的独占活动主机和列表数据源来创建一个设置面板  

<img src="./res/controls-data-source.gif" alt="效果图" width="850" height="320">

## Multi-Project  
在本仓库的这一步中主要学习组合多个 Kanzi Studio 项目来创建单个 Kanzi 应用程序：
- 使用公共资源（不用的资源尽量删除）
- 一个项目控制另外一个项目控件

<img src="./res/completed.png" alt="效果图" width="850" height="320">

## Android Getting Started
在本仓库的这一步中主要学习使用 Kanzi Android 框架 (droidfw) 开始开发 Android 应用程序：
- 在 Android 视图中显示 Kanzi 预制件
- 使用 Kanzi Java API 访问和修改应用程序
- 创建一个 Android Activity并在该Activity中显示 Kanzi 内容

>[!NOTE]当您想要为 Android 平台创建应用程序，并且打算广泛使用 Android API 和服务时，请使用 Kanzi Android 框架 (droidfw)。
>Kanzi Android 框架 (droidfw) 是一个专门用于开发 Android 版 Kanzi 应用的框架。它公开了 Kanzi Java API，允许您完全用 Java 或 Kotlin 编写应用和插件代码。您无需编写任何 C++ 或 JNI 代码，但仍可以使用原生 Kanzi 插件。Kanzi Android 框架 (droidfw) 提供与 Android UI 的强大集成，包括支持多个同时基于 Kanzi 的视图以及 Kanzi 和 Android UI 元素的灵活组合。Kanzi Android 框架 (droidfw) 与 Android Choreographer 集成，后者在 Android UI 线程中运行 Kanzi 主循环任务。这使您可以从应用代码中使用 Kanzi Java API，而无需调度程序机制。

<img src="./res/android-getting-started-completed.gif" alt="效果图" width="850" height="550">

## Android Data Source (※)
在本仓库的这一步中主要学习使用为Android 版 Kanzi 应用程序创建数据源
- 使用 Kanzi Java API 创建数据源。
- 使用Android API来支持数据源。
- 确保与无法使用 Android API 的Kanzi Studio Preview兼容。

<img src="./res/android-data-source-complete.gif" alt="效果图" width="650" height="350">

## Rotate a 3D Car model
在本仓库的这一步中主要学习使用Scroll View 2D 旋转3D车模

<img src="./res/rotation-completed.gif" alt="效果图" width="650" height="350">

## Input UI Navigation
本仓库的这一步中主要学习使用Input输入控制UI焦点

- 焦点获取和取消
- 焦点导航

<img src="./res/preview-navigate-lists.gif" alt="效果图" width="850" height="550">

## Pan Zoom Tap
本仓库的这一步中主要学习Tab Zoom Pan 方式操作地图

- Pan
- Zoom
- Tap

<img src="./res/Pan Zoom Tap.gif" alt="效果图" width="850" height="550">

## Drag and Drop
本仓库的这一步中主要学习使用C++代码控制拖动按钮效果：
- DragAndDropManipulator控制器实现拖拽事件
- Animation实现动画shake效果
- C++动态创建对象和绑定属性
- 容器对象迭代器使用

<img src="./res/drag-and-drop-completed.gif" alt="效果图" width="850" height="550">

