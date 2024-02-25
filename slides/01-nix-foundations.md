---
marp: true
paginate: true
---
# ❄️ Nix Foundations

Foundations lecture on the Nix ecosystem.
</br>
**instructor:** Julius Koskela
**email:** <julius.koskela@unikie.com>
**github:** github.com/juliuskoskela
**linkedin:** linkedin.com/in/julius-koskela/

---

## 1. Introduction to Nix :triangular_flag_on_post:

---

### The Nix Ecosystem

- Nix is a package manager.
- Nix is a domain spesific functional programming language.
- `nix` is a command line interface to interact with the Nix ecosystem.
- `nixpkgs` is a package repostory.
- NixOS is a Linux distribution which integrates deeply with the Nix ecosystem.
- Flakes are a "new" Nix system for extending the capabilities of Nix.

---

### Why do we need Nix?

correctness = complete + no interference

---

## Advantages of Nix

- Reproducible builds
- Per-project environments
- Declarative and composable system configuration
- Reliable upgrades and rollbacks
- Cross-platform package management
- Enhanced security

---

### Disadvantages of Nix

- High learning curve of the Nix language
- Insufficient documentation and learning materials
- Nix code is hard to debug
- Design is still evolving with major features that are still not part of mainline.

---

## 2. Theoretical Framework :mortar_board:

---

### Functional Package Management

Nix adopts a functional approach to package management, drawing inspiration from functional programming principles. In this context, packages are treated as functions of their inputs (source code, dependencies, build scripts, etc.), and the build process is considered a pure function. This means that for the same inputs, a package build function always produces the same output (the built package), ensuring reproducibility and predictability.

---

### Immutable Store

Nix stores all packages in an immutable store, where each package is stored in a directory that includes a hash of all inputs that went into building the package. This hashing mechanism ensures that any change in the inputs will result in a different output directory, thereby eliminating conflicts and ensuring that packages do not interfere with each other. This approach also facilitates atomic upgrades and rollbacks, as changes can be made by simply changing which versions of packages are referenced.

---

### Declarative Configuration

Nix and NixOS embrace a declarative configuration model. Instead of imperatively specifying steps to configure a system, users declare the desired end state of the system. The Nix tools then ensure that the system is brought into that state. This approach makes configurations easily reproducible and portable across different machines.

---

### Dependency Isolation

Each package built by Nix operates in isolation from other packages, addressing the "dependency hell" problem. Because each package's dependencies are included in its unique path in the Nix store, different versions of the same library can coexist without conflict. This isolation also extends to runtime dependencies, ensuring that applications have access only to the dependencies they were built with.

---

### Garbage Collection

The immutable nature of the Nix store and the potential for multiple versions of packages to exist side by side necessitate an efficient mechanism for cleaning up unused packages. Nix includes a garbage collector that can remove packages that are no longer referenced by any user or system configuration, helping to manage disk space effectively.

---

### Profiles and Environments

Nix supports the concept of profiles and environments, allowing users to switch between different sets of packages (e.g., different versions of a development environment) atomically. This capability is built on the principles of immutability and functional package management, enabling users to experiment with or upgrade packages without affecting the stability of their main environment.

---

### Source and Binary Transparency

Nix aims to provide both source and binary transparency. It can build packages from source to ensure that builds are reproducible and to allow modifications. However, to speed up installation times, it also supports binary caches, where pre-built binaries are available. The use of hashes ensures that the binary corresponds exactly to the build inputs, maintaining integrity and reproducibility.

---

## 3. Derivations :wrench:

_In order to understand Nix we need to understand derivations._

---

- A Nix **derivation** is a specification for how to **build a package or output from source code or binary inputs**.
- It is described in a `.drv` file, containing attributes like the builder, inputs, environment variables, and output paths.
- Derivations **ensure reproducible builds** by specifying all dependencies and build steps.
- The **build process is isolated**, producing deterministic results independent of the user's environment.
- Results are **cached in the Nix store under a path that includes a hash of the derivation's inputs**, ensuring uniqueness.
- Any **change in inputs leads to a new path in the Nix store**, preserving immutability and reproducibility.

---

### How do we create a derivation?

- We create a Nix file, often `default.nix`, where we define our derivation using the `derivation` built-in or one of the many higher level abstractions such as `mkDerivation`.
- We build the derivation using `nix-build` or `nix build` if working with flakes.
- In our build root we see a symlink called `result`, which links to the correct hashed output path in `nix/store/`.

---

A simple derivation written using the `derivation` built-in function

```nix
# default.nix

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
➜ nix show-derivation
{
  "/nix/store/n555x1ha380l37929avmz6vzk63pwy2s-foo.drv": {
    "args": [
      "-c",
      "set -x\n/nix/store/kjpanj8sfda335sca7rswrywnma1m40c-coreutils-9.3/bin/mkdir -p $out/bin\n/nix/store/i6zjqpawh725z1lyg3alglzlabnzbjx7-gcc-wrapper-12.3.0/bin/gcc $src -o $out/bin/$name\n"
    ],
    "builder": "/nix/store/6payx2da66dbjl6vg15csxfb5hpf3df4-bash-5.2-p15/bin/bash",
    "env": {
      "builder": "/nix/store/6payx2da66dbjl6vg15csxfb5hpf3df4-bash-5.2-p15/bin/bash",
      "name": "foo",
      "out": "/nix/store/46jf62bbxlkqjjagsmly67dyxrbm18qp-foo",
      "src": "/nix/store/m55gwxlw17cg6zqsnpp7gl8hk3aamid6-foo.c",
      "system": "x86_64-linux"
    },
    "inputDrvs": {
      "/nix/store/52nwyaxq1p58m1kps8r4x1wxsh0d7q4q-bash-5.2-p15.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/ivv6b8j8lk97n29gkynakspcn25zscsp-gcc-wrapper-12.3.0.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      },
      "/nix/store/nmzx7qvsngamgvls4xz15jxlij1pgv8n-coreutils-9.3.drv": {
        "dynamicOutputs": {},
        "outputs": [
          "out"
        ]
      }
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

...or any of the language spesific build frameworks

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

1. Evaluate package definition, compute hashes, and create `.drv` file
2. Evaluate derivation output
3. Build package according to derivation

---

### Fixed Output Derivations (FODs)

Fixed-output derivations in Nix are a special kind of derivation that is used when the output of the build process is determined solely by the inputs specified in the derivation itself, and not by any other external factors. This concept is particularly important for ensuring reproducibility in builds, especially when dealing with resources that need to be fetched from the internet or other external sources.

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

### Derivations Summary

- Derivation is the fundamental building block of Nix.
- Derivations describe how packages are build using Nix.
- Derivations use hashing to preserve uniqueness of outputs.
- A derivation contains a complete description of the package's dependencies and build steps.

---

## 4. The Nix Language :memo:

---

- **Functional Language**: Nix is a purely functional language, designed specifically for package management and system configuration.
- **Declarative Syntax**: It uses a declarative syntax to specify how to build packages and configure systems, ensuring reproducibility.
- **Lazily Evaluated**: Expressions in Nix are evaluated lazily, meaning they are only computed when needed, optimizing resource usage.
- **Strongly Typed**: The language is strongly typed, but types are inferred, not explicitly declared by the user.

---

## 5. System Configuration :computer:

---

## 6. Modules :gear:

---

## 7. Flakes :snowflake:

_The missing piece of the Nix ecosystem._

---

### Flakes are motivated by a number of serious shortcomings in Nix

- While Nix pioneered reproducible builds, Nix expressions are
  not nearly as reproducible as Nix builds.

- Nix projects lack discoverability and a standard structure.

- There is no standard way to compose Nix projects.

- `nix-channel` needs a replacement: channels are hard to create,
  users cannot easily pin specific versions of channels, channels
  interact in _ad hoc_ ways with the Nix search path, and so on.

---

- **Introduction to a New Management Paradigm**: Flakes represent a novel approach to managing Nix projects and packages, aiming to improve upon traditional Nix workflows.
- **Enhanced Reproducibility and Reliability**: They ensure that builds are more reproducible and reliable by precisely specifying dependencies.
- **Dependency Version Locking**: Flakes lock dependencies to specific versions, eliminating the "it works on my machine" problem by ensuring consistency across environments.

---

- **Declarative and Version-Controlled Configurations**: Allows for the entire project configuration to be declarative and stored in version control, making it easier to track changes and roll back if necessary.
- **Ease of Sharing and Reusing**: Facilitates the easy sharing and reusing of Nix expressions across different projects, enhancing modularity and collaboration.
- **Simplified Project Definitions**: Projects defined with flakes are simpler to understand and work with, thanks to their structured and standardized format.

---

- Flakes are pure by default and impure evaluation can be allowed using the `--impure` flag.

```bash
nix build
nix build --impure
```

- Normal Nix expressions on the other hand accept impurity by default and purity can be ensured with `--pure-eval`.

```bash
nix-build --pure-eval
nix-build
```

---

### Experimental Status of Flakes and Nix Command

---

### Flake Structure

---

### Building and Running Flakes

---

## 8. Summary :bulb:

---

Thank you!
