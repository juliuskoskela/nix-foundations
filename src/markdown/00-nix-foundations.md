---
marp: true
paginate: true
class: invert
---

# Nix Foundations :snowflake:

![bg left:33%](../images/lighthouse-painting.webp)

Foundations lecture on the Nix ecosystem.

<!--

1. Introduction to Nix
2. Concepts
3. Derivations
4. The Nix Language
5. System Configuration
6. Modules
7. Environment Management
8. Flakes
9. Ecosystem and Community
10. Summary

-->

---

## 1. Introduction to Nix :triangular_flag_on_post:

---

### What is Nix?

* **Nix**: is a package manager that can be used both on Linux and MacOS (darwin).
* **Nix**: is a domain specific functional programming language.
* **Nix**: is a build system that produces **derivations**.
* **Nixpkgs**: is a package repository made of Nix **derivations**.
* **NixOS**: is a Linux distribution which integrates deeply with the Nix ecosystem.

---

correct = complete + without interference

<!--

- Complete: Nix captures all dependencies explicitly, ensuring that every needed component is included for a package to run correctly.

- No Interference: By isolating packages in their own environments, Nix eliminates conflicts between different versions of the same software, maintaining system integrity.

- Correct: The combination of completeness and non-interference guarantees that software operates as intended, enhancing reliability and predictability.

-->

---

## Advantages of Nix

* Reproducible builds
* Per-project environments
* Declarative and composable system configuration
* Reliable upgrades and rollbacks
* Cross-platform package management
* Enhanced security

<!--

- Reproducible Builds: Guarantees that software builds will be identical across different environments and times, solving the "it works on my machine" problem by capturing all dependencies precisely.

- Per-project Environments: Allows developers to create isolated environments for each project, ensuring that dependencies for one project do not conflict with another, thereby simplifying dependency management and enhancing project portability.

- Declarative and Composable System Configuration: Enables users to specify system and application configurations in a high-level, declarative manner, making configurations easily understandable, maintainable, and extendable through composition.

- Reliable Upgrades and Rollbacks: Offers the ability to upgrade software or entire system configurations safely, with the added benefit of easy rollbacks to previous states, thus minimizing risks associated with updates.

- Cross-platform Package Management: Supports managing packages across different platforms, facilitating a unified package management experience for developers working in heterogeneous environments.

- Enhanced Security: By isolating packages and precisely controlling their dependencies, Nix reduces the surface area for security vulnerabilities, as packages are less likely to be affected by the insecure software installed elsewhere on the system.

-->

---

### Disadvantages of Nix

* High learning curve of the Nix language
* Insufficient documentation and learning materials
* Nix code cab be hard to debug
* Lack of developer tooling
* Design is still evolving with major features that are still not part of mainline.

<!--

- High Learning Curve: The unique approach of the Nix language, while powerful, presents a steep learning curve for new users, requiring a significant investment in time and effort to master.

- Insufficient Documentation: The ecosystem suffers from a lack of comprehensive and user-friendly documentation, making it challenging for newcomers to find the information they need to effectively use Nix.

- Debugging Complexity: Debugging Nix code can be particularly difficult due to its declarative nature and the abstraction of its operational mechanisms, often leading to a frustrating experience for developers.

- Evolving Design: The Nix ecosystem is still under active development, with major features and improvements yet to be integrated into the mainline. This ongoing evolution, while promising for the future, can introduce uncertainties and compatibility issues for current users.

-->

---

Nix can replace many existing tools streamlining the stack

* Package Managers
* Configuration Management Tools
* Environment Management Tools
* Infrastructure as Code (IaC) Tools
* Virtual Machine and Container Management

---

## 2. Concepts :mortar_board:

---

Nix employs a **functional package management** approach, treating packages as functions of their inputs to ensure reproducibility and predictability by always producing the same output for the same inputs.

<!--

- **Nix's Functional Approach**: Emphasizes predictability and reproducibility in package management.
- **Packages as Functions**: Every package is considered a function of its inputs, like source code and dependencies.
- **Pure Build Process**: Ensures that the same inputs always result in the same output, eliminating variability.
- **Benefits**: This methodology guarantees that software builds are consistent across different environments and times.

-->

---

Nix's **immutable store** uniquely identifies packages by hashing their inputs, enabling conflict-free management and facilitating atomic upgrades and rollbacks.

<!--

- **Immutable Package Store**: Nix places packages in a non-changeable store, ensuring stability and reliability.
- **Hashing Mechanism**: Incorporates a hash of all inputs in the package's directory name, making every package version distinct.
- **Conflict Elimination**: Changes in inputs lead to new hashes, preventing package conflicts and ensuring isolation.
- **Atomic Operations**: Supports seamless upgrades and rollbacks by switching references to different package versions, enhancing system reliability.

-->

---

Nix and NixOS use a **declarative system configuration** model, specifying the desired state rather than the steps to achieve it, for reproducibility and portability.

<!--

- **Declarative Model**: Focus on defining the "what" (end state) rather than the "how" (steps).
- **System Consistency**: Ensures systems can be reproduced exactly, aiding in reliability across different environments.
- **Ease of Portability**: Configurations can be easily moved and replicated on different machines.

-->

---

Nix ensures each package and its **dependencies operate in isolation**, solving "dependency hell" and allowing multiple versions to coexist without conflict.

<!--

- **Isolated Packages**: Each package is self-contained with its dependencies.
- **Solves Dependency Hell**: Multiple library versions can safely coexist.
- **Runtime Isolation**: Applications only access their specific dependencies, enhancing security and stability.

-->

---

Nix features a **garbage collector** to efficiently remove unused packages, managing disk space by cleaning up the immutable store.

<!--

- **Efficient Cleanup**: Automatically removes packages not referenced by any system or user configuration.
- **Disk Space Management**: Helps in maintaining optimal disk usage.
- **Supports System Health**: Ensures the system remains clean and efficient over time.

-->

---

Nix supports atomic switching between different **profiles and environments**, enabling safe experimentation and upgrades without destabilizing the main environment.

<!--

- **Flexible Environments**: Allows easy switching between sets of packages or development environments.
- **Atomic Operations**: Changes are made without affecting system stability.
- **Encourages Experimentation**: Users can try new packages or versions safely.

-->

---

Nix promotes **source and binary transparency**, building from source for reproducibility and utilizing binary caches for efficiency, with hashes ensuring integrity.

<!--

- **Reproducible Builds**: From source to ensure modifications are possible and builds are consistent.
- **Binary Caches**: Speed up installation times without compromising on integrity.
- **Hash-based Integrity**: Ensures binaries exactly match their source inputs, maintaining trust and reproducibility.

-->

---

## 3. Derivations :wrench:

_In order to understand Nix we need to understand derivations._

---

### What is a derivation?

* **Nix Derivation**: Specification for building packages from inputs.
* **`.drv` File**: Contains build attributes like builder, inputs, and outputs.
* **Reproducible Builds**: Derivations specify all dependencies and steps.
* **Isolated Build Process**: Ensures deterministic results, unaffected by user environment.
* **Cached Results**: Stored in Nix store with input-based hash for uniqueness.
* **Immutable Outputs**: Input changes result in new Nix store paths.

<!--

- A Nix derivation is essentially a blueprint for constructing a software package. It defines exactly how to turn source code or binary inputs into a runnable program or library.

- The `.drv` file is where the derivation details are stored, including the builder (the program that does the build), the inputs (such as source code and dependencies), environment variables needed for the build, and where to place the output.

- By explicitly listing every dependency and the steps needed to build the package, derivations eliminate the "it works on my machine" problem. Every build is guaranteed to be reproducible, provided the inputs remain the same.

- The build process for a derivation is completely isolated from the user's environment. This isolation ensures that the build results are deterministic and solely dependent on the derivation's inputs, not on any external state of the machine.

- Once built, the results are stored in the Nix store. Each package's location in the store includes a hash of all the derivation's inputs. This ensures that any change in the inputs will lead to a new, unique path, preventing conflicts and preserving the immutability of builds.

- The immutability of outputs in the Nix store is a cornerstone of Nix's design philosophy. Any change in a derivation's inputs necessitates a new build, leading to a new path in the Nix store. This model supports both the reproducibility of builds and the integrity of the system over time.

-->

---

### How do we create a derivation?

* We create a Nix file, often `default.nix`, where we define our derivation using the `derivation` built-in or one of the many higher level abstractions such as `mkDerivation`.
* We build the derivation using `nix-build` or `nix build` if working with flakes.
* In our build root we see a symlink called `result`, which links to the correct hashed output path in `nix/store/`.

<!--

- **Starting with a Nix File**: The first step in creating a derivation is to write a Nix file, typically named `default.nix`. This file is where you define the specifics of your package build, specifying all necessary details such as source files, dependencies, and build commands.
- **Using `derivation` or Higher-level Abstractions**: Within your Nix file, you can utilize the `derivation` function, a built-in mechanism for defining package builds in a low-level, granular way. For convenience and added features, you might opt for higher-level abstractions like `mkDerivation`, which simplify the process by abstracting common patterns and providing more intuitive interfaces for package definition.
- **Building with `nix-build` or `nix build`**: Once your derivation is defined, you compile or build it into a package using `nix-build` (for traditional Nix setups) or `nix build` (when working within the context of Nix Flakes). These commands interpret your Nix file, execute the build process as defined, and produce the final package.
- **Understanding the `result` Symlink**: After the build process completes, a symbolic link named `result` appears in your build root directory. This symlink points directly to the package's location in the `nix/store/`, prefixed with a hash that uniquely identifies the inputs and build process. This hashed path ensures that each build is uniquely addressable and cacheable, facilitating reproducibility and efficiency.
- **The Role of the Nix Store**: The `nix/store/` serves as the immutable repository for all packages and their dependencies. By placing the build output in the `nix/store/` under a hash-derived path, Nix guarantees that the build results are immutable, reproducible, and isolated from changes in the environment or other packages.

-->

---

A simple derivation written using the `derivation` built-in function

```nix
{pkgs ? import <nixpkgs> {}}:
derivation {
  system = "x86_64-linux";
  name = "foo";
  src = ./foo.c;

  args = [
    "-c"
    ''
      set -x
      ${pkgs.coreutils}/bin/mkdir -p $out/bin
      ${pkgs.gcc}/bin/gcc $src -o $out/bin/$name
    ''
  ];

  builder = "${pkgs.bash}/bin/bash";
}
```

---

View the derivation file `.drv` using `nix show-derivation`

```json
{
  "/nix/store/n555x1ha380l37929avmz6vzk63pwy2s-foo.drv": {
    "args": [
       /* ... */
    ],
    "builder": "/nix/store/6payx2da66dbjl6vg15csxfb5hpf3df4-bash-5.2-p15/bin/bash",
    "env": {
       /* ... */
    },
    "inputDrvs": {
      "/nix/store/52nwyaxq1p58m1kps8r4x1wxsh0d7q4q-bash-5.2-p15.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      /* ... */
    },
    "inputSrcs": [
      "/nix/store/m55gwxlw17cg6zqsnpp7gl8hk3aamid6-foo.c"
    ],
    "name": "foo",
    "outputs": {
      "out": {
        "path": "/nix/store/46jf62bbxlkqjjagsmly67dyxrbm18qp-foo"
      }
    },
    "system": "x86_64-linux"
  }
}
```

---

You can build derivations directly

```bash
➜  ~ nix-build /nix/store/n555x1ha380l37929avmz6vzk63pwy2s-foo.drv
➜  ~ ./result/bin/foo
Hello, World!
```

---

We usually use a higher level abstraction such as `mkDerivation`

```nix
# default.nix

{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "foo";
  src = ./.;
  buildPhase = ''
    mkdir -p $out/bin
    gcc $src/foo.c -o $out/bin/foo
  '';
}
```

---

...or any of the language specific build frameworks

```nix
# default.nix

{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ye6GH4pcI9h1CNpobUzfJ+2WlqJ98saCdD77AtSGafg=";
  };

  cargoSha256 = "sha256-ye6GH4pcI9h1CNpobUzfJ+2WlqJ98saCdD77AtSGafg=";

  ...
}
```

---

```nix
buildPythonPackage rec {
  version = "0.7.5";
  pname = "pickleshare";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca";
  };
}
```

---

```nix
buildGoModule rec {
  pname = "dive";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1pmw8pUlek5FlI1oAuvLSqDow7hw5rw86DRDZ7pFAmA=";
  };

  vendorSha256 = "sha256-YPkEei7d7mXP+5FhooNoMDARQLosH2fdSaLXGZ5C27o=";
}
```

---

### The Build Process

1) Evaluate package definition, compute hashes, and create `.drv` file
2) Evaluate derivation output
3) Build package according to derivation

<!--

- **Evaluating Package Definition**: The build process begins with the evaluation of the package definition contained within a Nix file. Nix computes the hashes of all inputs specified in the derivation—this includes source files, dependencies, and any other resources needed for the build. Based on these inputs, Nix generates a `.drv` file, which is a low-level, detailed specification of how to build the package. This file includes everything from the exact commands to run, to the environment variables needed, ensuring that the build can be reproduced exactly.

- **Derivation Output Evaluation**: Before the actual build starts, Nix evaluates the expected output of the derivation based on the `.drv` file. This step ensures that Nix understands what outputs to expect and how to cache them effectively. The evaluation of the derivation output also includes determining where in the `nix/store` the output will reside, using the computed hash as part of the path to guarantee uniqueness and immutability.

- **Building the Package**: With the `.drv` file evaluated and the expected outputs known, Nix proceeds to build the package according to the specifications in the derivation. This step is where the actual compilation or assembly of the package occurs, following the instructions laid out in the `.drv` file to the letter. The build environment is isolated from the rest of the system to ensure that only the specified inputs are used, making the build process deterministic and reproducible. Upon successful completion, the package is stored in the `nix/store` at the hashed path determined earlier, ready for use or deployment.

- **Reproducibility and Reliability**: This methodical approach to building packages—evaluating definitions, computing hashes, and following precise build instructions—ensures that Nix builds are highly reproducible and reliable. Any change in the inputs will lead to a different hash, a new `.drv` file, and consequently, a different output path in the `nix/store`, reinforcing the principles of immutability and reproducibility that are central to Nix's philosophy.

-->

---

### Fixed Output Derivations (FOD's)

* Used for deterministic output builds.
* Ensures reproducibility, especially with external inputs.
* Ideal for fetching resources from the internet.

<!--

- **Understanding FODs**: Fixed-output derivations are a cornerstone of Nix's approach to ensuring build reproducibility. They are specifically designed for situations where the build output can be precisely determined by the inputs provided in the derivation. This is in contrast to typical derivations, where the build process itself might introduce variability.

- **Role in Reproducibility**: The importance of FODs becomes evident when dealing with external resources, such as fetching source code from the internet. In these cases, the content fetched could potentially vary over time, introducing uncertainty into the build process. FODs address this by requiring a pre-specified hash of the expected output, ensuring that the fetched resource matches exactly what was intended, thus guaranteeing reproducibility.

- **Practical Usage**: When defining a fixed-output derivation in Nix, developers specify not only the URL or source from which to fetch the resource but also the expected hash of the output. Nix then fetches the resource, verifies that its hash matches the specified hash, and proceeds with the build only if they match. This mechanism is crucial for builds that depend on external sources, as it locks down the external dependency to a known, verifiable state, mitigating risks associated with external changes or tampering.

-->

---

Any derivation can provide an output hash to turn it into a FOD

```nix
stdenv.mkDerivation {
  # ...

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0lwdl06lbpnaqqjk8ap9dsags3bzma30z17v0zc7spng1gz8m6xj";
}
```

---

Now the derivation will fail if the output hash doesn’t match the expectation.

```bash
hash mismatch in fixed-output derivation '/nix/store/436kql2xd5acg3xkrdbgz3lzzmrazrfi-test-derivation':
  wanted: sha256:0lwdl06lbpnaqqjk8ap9dsags3bzma30z17v0zc7spng1gz8m6xj
  got:    sha256:0clr01hmi9hy6nidvr2wzh8k13acsx8vd25jhy48hxgnjkxw6kap
error: build of '/nix/store/mr6pk4af05xa5h9mihi85qzif1yp8l6a-test-derivation.drv' failed
```

---

### Summary

* Derivation is the fundamental building block of Nix.
* Derivations describe how packages are build using Nix.
* Derivations use hashing to preserve uniqueness of outputs.
* A derivation contains a complete description of the package's dependencies and build steps.

<!--

- **Foundation of Nix**: Start by emphasizing that derivations are not just a feature but the very foundation upon which Nix builds its package management system. This highlights the importance of understanding derivations for anyone working with Nix.

- **Building Blocks**: Explain that derivations are essentially instructions or blueprints for building packages. They include everything from where to fetch source code, which dependencies are needed, to how to compile or otherwise process the source code into a usable package.

- **Hashing for Uniqueness**: Discuss how Nix uses cryptographic hashing as a core mechanism to ensure that every output is unique and reproducible. Each derivation's hash includes all of its inputs, meaning any change in inputs results in a different output hash. This prevents conflicts and ensures that each package can coexist with others without interference.

- **Complete Dependency Descriptions**: Highlight that a derivation is not just about building a package but also about specifying its entire world of dependencies. This includes not only direct dependencies but also transitive ones, build tools, and environment settings. The complete description ensures that the build environment is precisely controlled and reproducible across different machines and setups.

- **Reproducibility and Reliability**: Conclude by reinforcing that the structured and detailed approach to describing package builds through derivations is what enables Nix's promise of reproducibility and reliability. Every build step and dependency is accounted for, which means that builds are consistent across different environments and over time, a significant advantage for developers and system administrators alike.

-->

---

## 4. The Nix Language :memo:

---

### Key Features

* Purely functional language made for package management and system configuration.
* Declarative syntax for reproducibility.
* Lazily evaluated expressions.
* Strongly typed with inferred types.

<!--

- **Functional Language Explained**: Nix is a purely functional language. This means every operation in Nix is a function that returns a value, which is crucial for its role in package management and system configuration. This design choice ensures that Nix operations are predictable and side-effect-free, leading to more reliable and reproducible builds.

- **Declarative Syntax**: Nix uses a declarative approach, where you specify "what" you want rather than "how" to achieve it. This syntax simplifies the process of defining complex package dependencies and system configurations, making them easier to understand, maintain, and ensure reproducibility across different environments.

- **Lazily Evaluated Expressions**: Lazy evaluation, a key feature of Nix that means expressions are only evaluated when their values are needed. This can significantly improve performance and efficiency, especially in complex configurations with many conditional elements.

- **Strong Typing with Inferred Types**: Nix is strongly typed, which helps catch errors early in the package management process. However, Nix simplifies the developer experience by inferring types instead of requiring them to be explicitly declared. This strikes a balance between safety and ease of use, allowing developers to write concise, error-resistant code without the verbosity often associated with strongly typed languages.

-->

---

We can evaluate Nix expressions using the `nix repl` command

```bash
➜  ~ nix repl
Welcome to Nix 2.18.1. Type :? for help.
```

A most basic Nix expression could be...

```bash
nix-repl> 1 + 2
3
```

---

In Nix we can define functions in the form:

```nix
arg: expr
```

which translates to:

```bash
nix-repl> f = x: x + 1
nix-repl> f 2
3
```

---

### Basic Types

```nix
let
  integer = 42;
  float = 3.14;
  string = "Hello, World!";
  multiline = ''
    Hello,
    World!
  '';
  boolean = true;
  list = [ 1 2 3 ];
  set = { a = 1; b = 2; };
  path = /nix/store;
  uri = https://nixos.org;
  null = null;
in
```

---

We can declare local variables using the `let ... in` statement.

```nix
let
  a = 1;
  b = 2;
in
  a + b
```

---

The `import` statement loads, parses and imports a nix expression.

```nix
# Import a local file named `default.nix` in the same directory
myPackage = import ./default.nix;

# Import a local file specifying a relative path
myLibrary = import lib/myLibrary.nix;
```

---

We can import from `$NIX_PATH` using <>.

```nix
# Import Nixpkgs from NIX_PATH denoted by <>
pkgs = import <nixpkgs> {};

# Import Nixpkgs with an overlay
pkgs = import <nixpkgs> { overlays = [ (self: super: { /* overlay definition */ }) ]; };
```

---

We can give arguments, override settings and use conditionals when importing.

```nix
# Import a file with arguments
customConfig = import ./config.nix { option = true; };

# Importing Nixpkgs with custom configuration
pkgs = import <nixpkgs> { config = { allowUnfree = true; }; };

# Dynamic import based on a condition
pkgs = import (if condition then ./path/to/true.nix else ./path/to/false.nix) {};
```

---

We can import from the internet.

```nix
# Importing a flake
pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/master.tar.gz") {};

# Importing from a Git repository
let
  myLibSrc = builtins.fetchGit {
    url = "https://github.com/username/repository.git";
    rev = "revision";
  };
in
  import "${myLibSrc}/path/to/nix/file.nix"
```

---

 We use `inherit` in order to bring a variable into the current scope.

```nix
let
  pkgs = import <nixpkgs> {};
in
  { inherit pkgs; }
```

---

The `with` statement introduces an attrset's value contents into the lexical scope of the expression which follows.

```nix
let
  myattrset = { a = 1; b = 2; };
in
  with myattrset; "In this string we have access to ${toString a} and ${toString b}"
```

---

We can define recursive attribute sets with `rec`.

```nix
rec {
  x = y - 100;
  y = 123;
}.x.
```

---

The ... inside the curly braces means that the function can accept an attribute set with any number of attributes.

```nix
{pkgs, ...}: { /* */ }
```

---

We can use destructuring to express our attribute sets more cleanly.

```nix
f = set: set.a + set.b;
```

```nix
f = { a, b }: a + b;
```

---

```nix
{ pkgs ? import <nixpkgs> {}, ... }:
let
  src = pkgs.fetchurl {
    url = "https://example.com/hello.tar.gz";
    sha256 = "1abc...";
  };
in pkgs.stdenv.mkDerivation rec {
  inherit src;

  name = "hello-world-${version}";
  version = "1.0";
  buildInputs = with pkgs; [ gcc make ];
  buildPhase = ''
    gcc -o hello src/hello.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin/
  '';
}
```

---

## 5. System Configuration :computer:

---

### Introduction to System Configuration: Overview and Importance

* Defining System Configuration in NixOS
* Declarative vs. Imperative Configuration
* Key Benefits of NixOS Configuration Approach

<!---

- System configuration in NixOS is specified declaratively in configuration files. This encompasses everything from installed packages, user accounts, and services to system settings such as network configurations.

- The difference between the declarative approach of NixOS and the imperative approaches of other operating systems is significant. In imperative systems, configurations are applied through a series of commands that modify the system state over time. NixOS, however, uses a declarative model where configurations declare the desired state of the system, and Nix ensures the actual system state matches this declared state.

- The declarative model offers several advantages, including reproducibility, reliability, and the ability to rollback to previous system states easily. This approach minimizes the risk of configuration drift and simplifies the replication of configurations across multiple machines, enhancing both the manageability and consistency of system environments.

--->

---

### The NixOS Configuration File

* The Heart of NixOS Configuration
* Location and Basic Structure
* Key Components of `configuration.nix`

<!---

- The Heart of NixOS Configuration: The `configuration.nix` file is central to NixOS, defining the entire system's setup. It encapsulates the system's desired state, from installed software and services to user management and system settings.

- Location and Basic Structure: Typically located at `/etc/nixos/configuration.nix`, this file is written in the Nix language. It starts with a set of curly braces `{}` that may include parameters for more advanced configurations and consists of a series of attribute assignments and function calls.

- Key Components of `configuration.nix`: Important sections include `environment.systemPackages` for specifying global packages, `services` for managing system services and daemons, `users.users` for user accounts, and `networking` for network settings. Each section is used to declare specific aspects of the system's configuration in a modular and composable way.

--->

---

```nix
# configuration.nix

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # ...
}
```

---

```nix
# hardware-configuration.nix

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "uas" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f456aad5-de10-4009-81b9-f155cf943fb2";
    fsType = "ext4";
  };

  # ...
}
```

---

```nix
environment.systemPackages = with pkgs; [
    helix
    curl
];
```

---

```nix
users.users.john = {
  isNormalUser = true;
  home = "/home/john";
  shell = pkgs.bash;
};
```

---

```nix
networking = {
  hostName = "my-hostname";
  networkmanager.enable = true;
};
```

---

```nix
services.xserver = {
  enable = true;

  displayManager.gdm = {
    enable = true;
    wayland = true;
  };
};
```

---

```nix
systemd.services.gps-recorder = {
  description = "GPS Recording Service";
  wantedBy = ["multi-user.target"];

  script = ''
    #!/usr/bin/env bash
    set -x
    # DEPLOYMENT_DIRECTORY is set by the deployment-start service
    OUTPUT_PATH=$DEPLOYMENT_DIRECTORY/${config.services.gps-recorder.output-folder}
    ${pkgs.coreutils}/bin/mkdir -p $OUTPUT_PATH
    RUST_LOG=info ${gpsRecorder}/bin/gps-recorder \
    --output-path $OUTPUT_PATH \
    --interval ${toString config.services.gps-recorder.interval-secs} \
    --hostname ${config.services.gps-recorder.hostname} \
    --port ${toString config.services.gps-recorder.port} \
  '';

  serviceConfig = {
    User = config.services.gps-recorder.user;
    Restart = "always";
  };

  unitConfig = {
    After = ["multi-user.target" "deployment-start.service"];
  };

  startLimitIntervalSec = 0;
};
```

---

```nix
boot.kernelPackages = pkgs.linuxPackages_latest;
```

---

```nix
boot.kernelPatches = [
  {
    name = "Bpmp virtualization host proxy device tree";
    patch = ./patches/0001-bpmp-host-proxy-dts.patch;
  }
  {
    name = "Bpmp virtualization host uarta device tree";
    patch = ./patches/0002-bpmp-host-uarta-dts.patch;
  }
  {
    name = "Bpmp virtualization host kernel configuration";
    patch = null;
    extraStructuredConfig = with lib.kernel; {
      VFIO_PLATFORM = yes;
      TEGRA_BPMP_HOST_PROXY = yes;
    };
  }
];
```

---

**Modular Configuration and Imports**: Organizing Configurations

---

**System Upgrades and Rollbacks**: Procedures and Features

---

**Advanced Features**: Flakes, Overlays, Security

---

**Best Practices**: Maintenance and Organization Tips

---

**Summary**: Recap and Discussion

---

## 6. Modules :gear:

---

## 7. Environment Management

---

* Nix focuses on isolated environments for precise dependency management
* Minimizes conflicts between projects or tasks
* Enhances reproducibility and consistency across environments

<!---

Nix emphasizes creating isolated environments for projects or development tasks to ensure dependencies are precisely managed and conflicts are minimized.

--->

---

<!---

`nix-shell` allows users to enter a shell environment with specific packages and dependencies, without permanently installing them.

--->

---

<!---

`nix-env` provides the tools for managing packages in a user's environment, allowing for flexible management of software without affecting the global system state.

--->

---

<!---

Nix profiles enable users to manage multiple sets of packages and configurations, with the ability to switch between them and rollback to previous states.

--->

---

<!---

Overlays allow users to extend or override packages in the Nixpkgs repository, enabling customization of environments at a granular level.

--->

---

<!---

Demonstrates how `nix-shell` can be used to specify and manage project-specific dependencies, ensuring consistent environments across different machines.

--->

---

## 8. Flakes :snowflake:

_The missing piece of the Nix ecosystem._

---

### Motivations Behind the Introduction of Flakes

* Reproducibility of Nix Expressions
* Discoverability and Standardization
* Composition of Nix Projects
* Replacement for `nix-channel`

<!---

Flakes were introduced as a solution to several pressing issues within the Nix ecosystem. Despite Nix's pioneering of reproducible builds, its expressions lacked similar levels of reproducibility, leading to inconsistencies across environments. The Nix community also faced difficulties with the discoverability of projects and a standardized approach to project organization, which Flakes aim to improve by providing a more structured and uniform way to handle Nix projects. Additionally, the composition of projects was marred by a lack of a standard method, creating unnecessary complexity. The `nix-channel` system, which had become cumbersome and limited in functionality, particularly in terms of version pinning and interaction with the Nix search path, is effectively replaced by Flakes. This new framework promises a more robust, standardized, and reproducible approach to managing Nix projects, addressing these critical shortcomings.

--->

---

### Flakes: A New Paradigm in Nix Project Management

* Reproducibility and Reliability
* Version Locking
* Sharing and Collaboration
* Simplified Project Structure

<!---

Flakes introduce a transformative approach to managing Nix projects and packages, emphasizing reproducibility, reliability, and consistency. By locking dependencies to specific versions, flakes eliminate variability between environments, ensuring that a project works the same way everywhere. This system allows project configurations to be fully declarative and version-controlled, simplifying change management and collaboration. The structured format of flakes also makes Nix expressions easier to share, reuse, and understand, streamlining project definitions and enhancing the overall development workflow.

--->

---

### Experimental Status of Flakes and Nix Command

* Flakes and Nix-command `nix <command>` are experimental
* Features not locked
* Nixpkgs only has a flake for compatibility reasons, but doesn't use "new Nix"
* Both are already widely adopted in the community

<!---

- The introduction of Flakes and the new Nix command represent significant advancements, offering solutions to enhance reproducibility, standardization, and ease of management within the Nix ecosystem.

- Both features are in an experimental phase, meaning they are being actively developed. Users should be aware that functionalities and interfaces may change as these features evolve.

- Given their experimental status, users should anticipate adjustments in their Nix workflows and be prepared for updates that may require learning new approaches or adapting existing practices.

- The Nix community is encouraged to actively participate by providing feedback on their experiences with Flakes and the new Nix command. Contributions and suggestions are valuable for refining these features and guiding their stable integration into the Nix ecosystem.

--->

---

### Flake Structure

```nix
# flake.nix

{
  description = "A simple flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
  };
}
```

<!---

The flake structure revolves around the `flake.nix` file, which is the heart of a flake's configuration. This file outlines all the necessary components, including inputs and outputs, to define the flake's dependencies and what it aims to provide.

- **Flake.nix File**: This is the primary file where the flake's configuration is defined. It determines how the flake behaves and interacts with other components in the Nix ecosystem.

- **Inputs**: Here, dependencies of the flake are specified. These can include other flakes, Nixpkgs versions, or any resources necessary for the flake's operation. In the example, `nixpkgs` is defined as an input with a specific GitHub URL pointing to a Nixpkgs repository version.

- **Outputs**: This section describes what the flake offers, such as Nix packages, NixOS modules, or other assets. Outputs are functions of the inputs, meaning the output can dynamically change based on the inputs' state. In the provided example, the flake offers a single package, `hello`, sourced from the specified `nixpkgs` input.

This minimal setup exemplifies a flake that essentially repackages an existing package (`hello`) from Nixpkgs, showcasing the fundamental aspects of flake structure.

--->

---

### Building and Running Flakes

```bash
nix build .#hello
nix run .#hello
nix run github:owner/repo#packageName
```

<!---

To work with Flakes, two primary commands are often used: `nix build` and `nix run`. These commands allow for the building and execution of packages defined within a flake, respectively.

- **Building a Flake**: The `nix build` command compiles or assembles the software specified in the flake. For example, `nix build .#hello` builds the `hello` package defined within the current flake.

- **Running a Flake's Package**: After building, you can directly run the package using `nix run`. For instance, `nix run .#hello` executes the `hello` package, assuming it is an executable.

These commands demonstrate the straightforward process of building and running software managed by flakes. This process emphasizes the ease of use and reproducibility that Flakes bring to the Nix ecosystem, providing clear and concise methods for software deployment.

--->

---

Flakes are pure by default and impure evaluation can be allowed using the `--impure` flag.

```bash
nix build
nix build --impure
```

Normal Nix expressions on the other hand accept impurity by default and purity can be ensured with `--pure-eval`.

```bash
nix-build --pure-eval
nix-build
```

---

## 9. Ecosystem and Community

---

### Introduction to the Nix Ecosystem and Community

<!---

Begin with an overview of the Nix ecosystem, highlighting its core components: Nix, the package manager; NixOS, the operating system; Nixpkgs, the package repository; and Flakes, the latest approach to package and environment management. Emphasize the synergy between these components and the vital role the community plays in nurturing and advancing the ecosystem.

--->

---

### Nixpkgs, Package Management, and Community Resources

<!---

Dive into Nixpkgs, explaining how it serves as the backbone for package management in the Nix ecosystem, and detail the process of contributing to this repository. Then, highlight the community resources available for support and learning, including forums, IRC channels, and GitHub discussions, pointing out how these platforms facilitate knowledge sharing and collaboration among users and contributors.

--->

---

### Contributing to Nix and Real-World Applications

<!---

Outline the various ways individuals can contribute to the Nix ecosystem, from package maintenance and software development to writing documentation. Then, share success stories and real-world applications of Nix and NixOS to illustrate the impact and practical benefits of the ecosystem in various settings, from individual projects to organizational use.

--->

---

### Future Developments and Getting Involved

<!---

Discuss the future developments expected in the Nix ecosystem, including any planned features or improvements, to give a glimpse into the direction of Nix's evolution. Conclude by encouraging audience members to get involved, offering guidance on how to start contributing and becoming active members of the community, fostering a welcoming environment for newcomers.

--->

---

## 10. Summary :bulb:

---

### Summary: Key Takeaways from Nix Foundations

* **Comprehensive Introduction**: We started with an overview of Nix, exploring its unique approach to package management and system configuration, emphasizing reproducibility, reliability, and the declarative model.

* **Core Concepts**: Delved into the foundational concepts of Nix, including derivations, the Nix language, and how these elements work together to ensure system configurations and package dependencies are precisely managed and isolated.

* **Practical Applications**: Through examples, we've seen how Nix facilitates the creation of reproducible environments, manages dependencies, and allows for seamless rollback of system states, enhancing development and deployment workflows.

* **Advanced Features**: Introduced advanced Nix features like Flakes, which provide even greater control over package management and project development, ensuring even more reproducible environments.

* **Ecosystem and Community**: Highlighted the vibrant Nix ecosystem and the supportive community that plays a crucial role in its development. We explored the resources available for learning and collaboration, as well as how individuals can contribute to the growth of Nix.

* **Real-World Impact**: Shared success stories and practical applications, demonstrating the versatility and effectiveness of Nix in various settings, from personal projects to large-scale organizational deployments.

<!---

This series has provided a comprehensive introduction to Nix, covering its philosophy, key features, and practical applications. Attendees should now have a solid understanding of how Nix can transform system configuration and package management through its unique, declarative approach. The exploration of advanced features like Flakes and the insights into the ecosystem and community have aimed to equip participants with the knowledge and resources needed to start their journey with Nix, whether for personal or professional use. The shared success stories and applications of Nix have underscored its value and impact, encouraging further exploration and adoption of this powerful toolset.

--->

---

![bg cover](../images/pink-beach-painting.webp)
