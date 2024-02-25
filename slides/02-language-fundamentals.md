---
marp: true
paginate: true
---
# ❄️ Language Fundamentals

Nix language fundamentals workshop.
</br>
**instructor:** Julius Koskela
**email:** <julius.koskela@unikie.com>
**github:** github.com/juliuskoskela
**linkedin:** linkedin.com/in/julius-koskela/

---

## Nix Expressions

In the context of Nix, an "expression" refers to any piece of code that can be evaluated to produce a value. Nix expressions are the fundamental building blocks of Nix language, used to define everything from package configurations to entire system configurations in NixOS. The Nix language is a pure, lazy, functional language, meaning that:

- **Pure**: The result of a Nix expression depends solely on its inputs. Side effects (like modifying global state or performing I/O operations) are not allowed in the evaluation of an expression, ensuring reproducibility.
- **Lazy**: Nix expressions are evaluated on an as-needed basis. If a part of an expression is never used, it will not be evaluated.
- **Functional**: Functions are first-class citizens in Nix, and the act of building software is treated as the evaluation of a function.

---

### Components of Nix Expressions

Nix expressions can include:

- **Literals**: Basic values such as integers, strings, paths (e.g., `/nix/store...`), booleans, and null.
- **Variables**: Names that refer to values. Variables are bound to values using `let` bindings or function parameters.
- **Functions**: Blocks of code that take inputs and produce an output. Functions are used extensively for package definitions and system configurations.
- **Attribute sets**: Collections of key-value pairs, similar to records or dictionaries in other languages. Attribute sets are a fundamental data structure in Nix, used to organize and pass around configuration options.
- **Lists**: Ordered collections of values. Lists are used to manage multiple items, such as dependencies or configuration options that can occur multiple times.

---

### Examples of Nix Expressions

- A simple Nix expression that evaluates to a number:

  ```nix
  3 + 5
  ```

- A more complex Nix expression defining a package:

  ```nix
  stdenv.mkDerivation {
    name = "hello-world";
    src = ./src;
    buildCommands = [ "make" ];
    installCommands = [ "make install" ];
  }
  ```

- An expression using an attribute set:

  ```nix
  { pkgs, ... }:  # This is a function accepting an attribute set
  pkgs.firefox
  ```

---

### Use of Expressions in Nix

In Nix, expressions are used for:

- **Package Definitions**: Defining how to build a package from source code.
- **Configuration Management**: Specifying configurations for NixOS or for development environments.
- **Dependency Management**: Declaring dependencies of packages or entire system configurations.
- **Composing Software Environments**: Combining multiple packages into a coherent software environment, which can be deployed or developed against.

Expressions are evaluated by the Nix tooling to produce derivations, which are then built to create the final software artifacts. This process, driven by the evaluation of expressions, ensures that software builds are reproducible, dependencies are precisely managed, and configurations are declaratively specified.

---

Thank you!
