# swift-generated-asset-plugin

Generated an `assets.xcassets` catalog that loads colors when plugin is applied to a target.

> Note: This repo was created because I struggled to let colors be recognised. 
The problem was I added every individual `assets.xcassets/colorName.colorset/Content.json` file to the
outputFiles of the build command. This causes duplicated files. Just adding the folder makes SPM load the a
asset catalog correctly.

Take a look at the plugin ``GenerateColorAssets`` to find out how to do this if you struggle with the same. 

## Illustrate possible bug

[Can Swift plugin target sourceFiles contain generated files? - Development / Package Manager - Swift Forums](https://forums.swift.org/t/can-swift-plugin-target-sourcefiles-contain-generated-files/63479)

This is visible if you build the target `Foo` and go to the build log.
