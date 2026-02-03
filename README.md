# 🧛 ECS-based Vampire Survivors–like (3D)

This project is a **3D Vampire Survivors–style game** built in **Godot**, focused on experimenting with a **practical ECS-inspired architecture**.

---

## 🧠 Architecture Overview

The project follows an **Entity–Component–System (ECS) style** approach:

- **Entities** are Godot scenes (Player, Enemies, Ability Effects)
- **Components** are small, reusable scripts attached to entities
- **Systems** coordinate logic across many entities
- **Resources** define reusable data and behavior templates

This is **ECS-inspired**, not a pure ECS framework.

---

## 🧩 Core Concepts

### Entities

Entities are standard Godot scenes:

- Player
- Enemies
- Ability effect instances (slashes, projectiles, auras)

Entities contain minimal logic and are composed via components.

---

### Components

Components are **single-responsibility behaviors** that operate on their parent entity.

Examples:

- `FollowOwner` – keeps an entity attached to another
- `Lifetime` – automatically removes temporary entities
- `Hitbox` / `HurtBox` – damage interaction
- `Health`, `Damage`, `Movement`

Components are reusable and decoupled.

---

### Systems

Systems run every frame (or on events) and operate over entity groups.

Examples:

- `AbilitiesSystem` – updates player and enemy abilities
- `SwarmSystem` – enemy spawning and positioning
- `BehaviorSystem` – AI behavior coordination
- `LevelInitializer` – sets up player and level state

Systems do not own entity state; they orchestrate behavior.

---

## ⚔️ Abilities Architecture

Abilities use a **data + instance** model.

### AbilityData (Resource)

- Defines cooldowns, damage scaling, and metadata
- Owns activation logic
- Spawns ability instance scenes

### AbilitySlot (Runtime State)

- Stores level, cooldown timers
- References an AbilityData
- Held by the `Abilities` component

### Ability Instances

Spawned scenes containing:

- Visual effects
- Hitboxes
- Animations
- Components such as `FollowOwner` and `Lifetime`

---

## 🧍 Characters

Playable characters are defined as **Resource assets**:

- Health
- Energy
- Starting abilities
- Descriptive metadata

---

## 🎯 Design Goals

- Favor **composition over inheritance**
- Keep systems decoupled
- Avoid monolithic scripts
- Allow abilities to be shared by players and enemies

---

## 🚧 Project Status

This project is experimental and focused on architectural exploration.
Gameplay content and balance are secondary to system design.

---
