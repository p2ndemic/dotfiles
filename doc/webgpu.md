Implementation Status
This page shows the current implementation status of the WebGPU API spec in browsers. It also lists some resources (samples, demos) for enthusiastic web developers. Also note the WebGPU Shading Language spec that's hosted separately.

The public-gpu@w3.org mailing list is a good place to ask questions or provide feedback on the API.

You can also join the chat on Matrix in the "Web Graphics" Matrix Community: #webgraphics:matrix.org. The general WebGPU channel is #WebGPU:matrix.org.

Implementation Status
Chromium (Chrome, Edge, etc.)
WebGPU has begun shipping to Mac/Windows/ChromeOS in Chrome 113 and Edge 113! As always, developers should develop against Chrome Canary or Edge Canary. Increased reach, other platforms, and bug fixes are ongoing.1

Android	Chrome OS	Linux	Mac	Windows
121	113	👷 Behind a flag2	113	113
1 For details, look at the WebGPU-related components in the Chromium/Dawn/Tint issue tracker: Search these before filing new bugs.
2 The chrome://flags/#enable-unsafe-webgpu flag must be enabled (not enable-webgpu-developer-features). Linux experimental support also requires launching the browser with --enable-features=Vulkan. (If this doesn't work try --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan and please comment on #5022!)

Firefox and Servo
These browser implementations are based on the WGPU project.

Firefox
WebGPU is enabled by default in Nightly Firefox builds.

All the issues and feature requests are tracked by the Graphics: WebGPU component in Bugzilla. For initial release, please see the webgpu-mvp bug. Firefox tentatively plans to ship with Firefox 141.

Servo
Work in progress, enabled by "dom.webgpu.enabled" pref.

Safari (In Progress)
WebGPU is enabled by default in Safari Technology Preview.

In macOS Sequoia betas it is testable via the "Feature Flags" in Safari Settings. See release notes for Safari Technology Preview 185.

In the iOS 18 betas and visionOS 2 betas, it is available via Settings -> Apps -> Safari -> Advanced -> Feature Flags -> WebGPU

Materials
Samples
webgpu-samples for Chrome and Firefox (uses WGSL, or GLSL via SPIR-V)

wgpu-rs samples for Firefox and Chrome (uses GLSL via SPIR-V), compiled from Rust

WebKit/Safari Demos (uses WSL)

hello-webgpu-compute.glitch.me: simple demo with both the SPIR-V and WSL paths

Demos
webgpu-clustered-shading
Meta-balls
Spookyball - 3D version of "Breakout", Halloween theme.
WebGPU Playground - a student project at Imperial College London. feedback
Articles
Get started with GPU Compute on the Web
Frameworks
Babylon.js (uses SPIR-V)
WebGPU documentation
Performance comparison demo of WebGL Forest vs WebGPU Forest (uses SPIR-V)
