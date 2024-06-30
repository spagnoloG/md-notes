# Tracks

- `/var/log` - Location of kernel and software logs
- `shred -vzfu auth.log` -read manual, tool that overrites file many times causing data to be unrecoverable

- `.bash_history` - do not forget this bro

### Moonwalk

Or even better; to not worry about tracks you make on a server use moonwalk binary.

Hides everything you do; even logs.

- [moonwalk](https://github.com/mufeedvh/moonwalk)

Then to start hidden session issue:

```bash
moonwalk start
```

After finishing:

```bash
moonwalk stop
```

When doing any recon/exploitation and messing with any files, get the `touch` timestamp using:

```bash
moonwalk get ~/.bash_history
```
