<!--
 * @Author: XQ
 * @Date: 2024-11-19 10:37:22
 * @LastEditTime: 2024-11-29 17:46:37
 * @LastEditors: XQ
 * @Description: 
 * @FilePath: \undefinedd:\xuqiang\github\Kanzi-Demos\readme.md
-->
# 介绍
本仓库主要是前期学习Kanzi技术的一个过程记录

# 仓库分类介绍和说明
## 基础向导
### Getting Started
在本仓库的这一步中主要学习：  
- 熟悉Kanzi里面的一些简单流程
- 按钮 
- 状态切换 
- 属性控制 
- 资源加载 

<img src="./res/getting-started-completed.gif" alt="效果图" width="850" height="550">

### First Application
在本仓库的这一步中主要学习：  
- 属性
- Kanzi状态切换 
- Trajectory List Box使用 
- 效卡片制作 
- 布局  
![效果图](./res/First%20Application.gif)  
### Activity
在本仓库的这一步中主要学习：

- 关于不同类型的Activity节点

- 如何使用活动浏览器创建具有活动节点的应用程序结构

- 如何使用状态管理器控制活动节点的激活状态

<img src="./res/ab-left-area.gif" alt="效果图" width="850" height="550">

### Data Triger
在本仓库的这一步中主要学习：
- 如何使用条件来控制应用程序 UI
- 如何通过创建弹出窗口来控制组成 UI 的活动的激活状态，应用程序仅在满足数据触发器中的条件时才会显示这些弹出窗口
- 绑定表达式的形式在数据触发器中设置条件

<img src="./res/dt-complete.gif" alt="效果图" width="850" height="550">

## UI Controls 界面控制
### Components  
在本仓库的这一步中主要学习自定义控件：
- Toggle Button  

<img src="./res/toggle-button-final.gif" alt="效果图" width="650" height="350">

- Button  

<img src="./res/button-states.gif" alt="效果图" width="650" height="350">

- Slider

<img src="./res/slider-value-indicator.gif" alt="效果图" width="650" height="350">

- List Box

<img src="./res/list-box.gif" alt="效果图" width="650" height="350">

### Data Source
在本仓库的这一步中主要学习应用程序使用数据源插件：
- 数据源将用户界面与应用程序数据分离
- 通过定义 Kanzi Engine 数据源插件来定义数据源的格式和结构
- 定义 XML 数据源以及如何在 Kanzi Studio 项目中使用该数据源中的数据向 Kanzi 应用程序提供数据

<img src="./res/end-of-step-3.png" alt="效果图" width="850" height="350">

### Data-Driven Activities
在本仓库的这一步中主要学习使用数据驱动来显示Activity：
- 数据驱动的独占活动主机和列表数据源来创建一个设置面板  

<img src="./res/controls-data-source.gif" alt="效果图" width="850" height="320">

### Multi-Project  
在本仓库的这一步中主要学习组合多个 Kanzi Studio 项目来创建单个 Kanzi 应用程序：
- 使用公共资源（不用的资源尽量删除）
- 一个项目控制另外一个项目控件

<img src="./res/completed.png" alt="效果图" width="850" height="320">

### Android Getting Started
在本仓库的这一步中主要学习使用 Kanzi Android 框架 (droidfw) 开始开发 Android 应用程序：
- 在 Android 视图中显示 Kanzi 预制件
- 使用 Kanzi Java API 访问和修改应用程序
- 创建一个 Android Activity并在该Activity中显示 Kanzi 内容

>[!NOTE]当您想要为 Android 平台创建应用程序，并且打算广泛使用 Android API 和服务时，请使用 Kanzi Android 框架 (droidfw)。
>Kanzi Android 框架 (droidfw) 是一个专门用于开发 Android 版 Kanzi 应用的框架。它公开了 Kanzi Java API，允许您完全用 Java 或 Kotlin 编写应用和插件代码。您无需编写任何 C++ 或 JNI 代码，但仍可以使用原生 Kanzi 插件。Kanzi Android 框架 (droidfw) 提供与 Android UI 的强大集成，包括支持多个同时基于 Kanzi 的视图以及 Kanzi 和 Android UI 元素的灵活组合。Kanzi Android 框架 (droidfw) 与 Android Choreographer 集成，后者在 Android UI 线程中运行 Kanzi 主循环任务。这使您可以从应用代码中使用 Kanzi Java API，而无需调度程序机制。

<img src="./res/android-getting-started-completed.gif" alt="效果图" width="850" height="550">

### Android Data Source (※)
在本仓库的这一步中主要学习使用为Android 版 Kanzi 应用程序创建数据源
- 使用 Kanzi Java API 创建数据源。
- 使用Android API来支持数据源。
- 确保与无法使用 Android API 的Kanzi Studio Preview兼容。

<img src="./res/android-data-source-complete.gif" alt="效果图" width="650" height="350">

### Rotate a 3D Car model
在本仓库的这一步中主要学习使用Scroll View 2D 旋转3D车模

<img src="./res/rotation-completed.gif" alt="效果图" width="650" height="350">

## Input 输入输出
### Input UI Navigation
本仓库的这一步中主要学习使用Input输入控制UI焦点

- 焦点获取和取消
- 焦点导航

<img src="./res/preview-navigate-lists.gif" alt="效果图" width="850" height="550">

### Pan Zoom Tap
本仓库的这一步中主要学习Tab Zoom Pan 方式操作地图

- Pan
- Zoom
- Tap

<img src="./res/Pan Zoom Tap.gif" alt="效果图" width="850" height="550">

### Drag and Drop
本仓库的这一步中主要学习使用C++代码控制拖动按钮效果：
- DragAndDropManipulator控制器实现拖拽事件
- Animation实现动画shake效果
- C++动态创建对象和绑定属性
- 容器对象迭代器使用

<img src="./res/drag-and-drop-completed.gif" alt="效果图" width="850" height="550">

## Rendering 渲染
### Material and Textures
本仓库的这一步中主要学习材质和纹理的使用
- 导入Assets
- 创建材质和纹理
- 修改材质和纹理参数
- 双色车身

<img src="./res/double-paint.png" alt="效果图" width="850" height="750">

### Gaussian Blur 高斯模糊
本仓库的这一步中主要学习高斯模糊
- Gaussian blur
- 数据触发器
- 数据绑定
- Apply Property Action
- 状态管理器

<img src="./res/blur-completed1.gif" alt="效果图" width="850" height="450">

### Bloom 光晕
本仓库的这一步中主要学习车灯光晕效果
- 渲染通道
- 渲染材质文件和材质类型
- Rendering Pass相关组合
- 数据绑定
- bloom参数调节

<img src="./res/bloom-completed.gif" alt="效果图" width="850" height="450">

### Stencil 模板
本仓库的这一步中主要学习如何使用标签、过滤器和渲染过程将模板应用于 3D 内容并仅渲染模板定义的区域。
- Tag和Tag Filter
- 渲染模板
- 渲染管线参数设置
- 模板测试

<img src="./res/stencil-completed.gif" alt="效果图" width="850" height="350">

### Reflections
本仓库的这一步中主要学习反射
- 面剔除
- 渲染通道
- 对象源

<span style="color: red;">[**知识点**]</span>：
**"Reflections"**通常指的是物体表面反射的光线效果，这可以包括镜面反射、环境反射等多种形式。
具体来说，反射可以分为以下几种类型：
1. **镜面反射 (Specular Reflection)**:
   - 镜面反射是指光线从光滑表面反射出来的现象。这种反射遵循光的反射定律（入射角等于反射角），并且通常会产生清晰的反射图像。
   - 在3D渲染中，镜面反射通常用于模拟金属或光滑表面的高光效果。
2. **漫反射 (Diffuse Reflection)**:
   - 漫反射是指光线从粗糙表面散射出来的现象。这种反射不遵循特定的方向，而是向各个方向散射，因此不会产生清晰的反射图像。
   - 漫反射通常用于模拟非金属表面（如布料、木材等）的光照效果。
3. **环境反射 (Environment Reflection)**:
   - 环境反射是指物体表面反射周围环境的效果。这种反射可以捕捉到周围的环境光和颜色，并将其反射到物体表面。
   - 在3D渲染中，环境反射通常通过环境贴图（如立方体贴图）来实现，以模拟真实的环境光照效果。
4. **倒影 (Planar Reflection)**:
   - 倒影特指物体在平面上（如水面、镜子等）形成的反射图像。这种反射通常是镜面反射的一种特殊形式。
   - 在3D渲染中，倒影可以通过多种方法实现，包括使用反射贴图、屏幕空间反射（SSR）或预渲染的反射纹理。

&nbsp;&nbsp;在Kanzi中的应用在Kanzi中，反射效果可以通过不同的材质类型和设置来实现。以下是一些常见的方法：
1. **使用PBR材质**:•物理基础渲染（PBR）材质类型支持复杂的反射效果，包括镜面反射和环境反射。你可以通过设置金属度（Metallic）、粗糙度（Roughness）等参数来控制反射的强度和质量。
2. **环境贴图**:•使用环境贴图（如立方体贴图）来模拟环境反射。Kanzi 支持导入和使用HDR环境贴图，这些贴图可以提供非常逼真的环境光照效果。
3. **屏幕空间反射 (SSR)**:•屏幕空间反射是一种实时渲染技术，可以在屏幕上直接计算反射效果。这种方法适用于动态场景，但可能需要较高的计算资源。
4. **反射探针 (Reflection Probes)**:•反射探针是一种预计算的方法，它在场景中放置多个探针，每个探针捕获周围环境的反射信息。这些信息可以用来为附近的物体提供反射效果。

<img src="./res/reflections-completed.gif" alt="效果图" width="850" height="500">

### Progressive Rendring
本仓库的这一步中主要学习渐进式渲染技术
- 多渲染管道
- 单帧渲染分成多帧渲染
- Tag和Tag Filter绑定

<img src="./res/progressive-rendering-completed.gif" alt="效果图" width="850" height="350">

## Animations
### Keyframe Animations 
本仓库的这一步中主要学习关键帧动画
- Animation Clip Editor 动画剪辑编辑器
- Animation Clip
- Animation Data
- Timeline Entry
- Timeline Sequence

<span style="color: red;">[**知识点**]</span>：注意清除不需要的关键帧数据

<img src="./res/keyframe---final.gif" alt="效果图" width="850" height="450">

### Interpolate Animations
本仓库的这一步中主要学习插值动画
- 插值属性
- 插值触发器
- 插值表达式


<img src="./res/interpolate-completed.gif" alt="效果图" width="850" height="550">

# 如何提高渲染性能
## 采用Progressive Rendering技术  
&nbsp;&nbsp;**Progressive Rendering(渐进式渲染)** 是一种渲染技术，它将复杂的渲染任务分解成多个小部分，并在多帧中逐步完成这些部分。这种方法可以显著减少单帧的渲染时间，从而提高应用程序的性能和响应性。渐进式渲染通常用于处理非常复杂的场景或需要高计算量的渲染任务，如高质量的光照、阴影、反射等。  
**为什么使用渐进式渲染？**
1. 减少单帧渲染时间：  
   •渐进式渲染通过将渲染任务分布在多帧中，减少了每帧的渲染时间。这使得应用程序能够更快地响应用户输入，提供更流畅的用户体验。
2. 提高性能：  
   •对于资源密集型的渲染任务，渐进式渲染可以显著提高性能。通过分摊工作负载，GPU 可以更有效地利用其计算能力。
3. 实现高质量渲染：  
   •渐进式渲染允许在多帧中逐步累积渲染结果，从而实现更高的视觉质量。这对于需要复杂光照和全局光照效果的场景尤为重要。
4. 平滑过渡：    
   •渐进式渲染可以提供平滑的视觉过渡，因为每一帧都在逐步改进最终图像的质量。用户可以看到图像逐渐变得清晰和详细。

