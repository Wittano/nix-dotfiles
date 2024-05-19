{ buildDotnetModule
, dotnetCorePackages
}: buildDotnetModule {
  pname = "avalonia";
  version = "0.0.0";

  src = ./.;
  projectFile = "Avalonia/Avalonia.csproj";

  dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
  nugetDeps = ./deps.nix;
}
