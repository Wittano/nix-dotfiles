{ buildDotnetModule
, dotnetCorePackages
}: buildDotnetModule {
  pname = "dotnet";
  version = "0.0.0";

  src = ./.;
  projectFile = "Dotnet/Dotnet.csproj";

  dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
  nugetDeps = ./deps.nix;
}
