---
marp: true
paginate: true
class: invert
---

A command to show a derivation of a package

```bash
➜  ~ nix derivation show nixpkgs#hello | wc -l
70
```

The recursive flag `-r` gives us the full closure

```bash
➜  ~ nix derivation show -r nixpkgs#hello | wc -l
17996
```

---
