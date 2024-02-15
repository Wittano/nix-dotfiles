# Nix templates
List of avaiable templates:
- scala - basic template for [Scala 3](https://scala-lang.org) project with sbt project builder
- compose-destkop - basic template for [Kotlin](https://kotlinlang.org) project for desktop application. Template include special script, that fixes problem with SKIA engin(invalid localization of external libraries) for [jetpack-compose](https://developer.android.com/jetpack/compose) on NixOS. Script is working on NixOS and isn't recommend use it for non-NixOS systems. It should be unnecessary
- go - basic template for [Go](https://go.dev) project with build Go project to exetuable program for Nix. [Link to buildGoModule source code](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix)