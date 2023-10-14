# Nixos

### Managing system generations 

###### List system generations 

```
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

###### Delete old generations

```bash
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
```
###### Collect garbage

```bash
sudo nix-collect-garbage -d
```

######  Hard link identical files (remove duplicate libraries)

```bash
sudo nix-store --optimize
```

file: clean-nix.sh
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d
sudo nix-store --optimize
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```


