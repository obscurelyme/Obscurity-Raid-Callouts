# Obscurity Raid Callouts

This is a simple backend addon for raid leads and raid assitants to perform real time speech to text/visual cues during raid and dungeon boss encounters.

Works in conjunction with the [Obscurity Raid Callouts](https://wago.io/o4AgO_5rF) WeakAura package, which serves as the frontend to this addon.

This addon relies on various macros to send comms over the wire to listeners in order to send/receive instructions about what to do during the raid.

Standard format for `SendComm` looks like this...

```
Obscurity:SendComm([COMMAND], [COOLDOWN?], [TARGET?], [ARG2?], [ARG3?])
```

Where Cooldown, target, args2 and 3 are totally optional

### Macro Examples

The following macro is an example on how to call for Guardian Spirit CD on your mouseover target.

```
/run Obscurity:SendComm("OBSCURITY_COOLDOWN", "OBSCURITY_GUARDIAN_SPIRIT", UnitName("mouseover"))
```

Here is another way to call for a cooldown without asking for a particular target in mind

```
/run Obscurity:SendComm("OBSCURITY_COOLDOWN", "OBSCURITY_TRANQUILITY")
```

Other helpful raid callouts include...
- **Bait**: OBSCURITY_BAIT - Calls to bait, raid/party member should be aware of what "bait" means in the context of the encounter
- **Soak**: OBSCURITY_SOAK - Calls to soak, raid/party member should be aware of what "soak" means in the context of the encounter
- **Stack**: OBSCURITY_STACK - Calls to stack, raid/party member should be aware of what "stack" means in the context of the encounter
- **Wipe**: OBSCURITY_WIPE - Calls for a raid wipe
- **Spread**: OBSCURITY_SPREAD - Calls to spread out
- **Cooldown**: OBSCURITY_COOLDOWN - Calls for a Specific Cooldown, optionally can call for a CD to be used on a specific raid/party member