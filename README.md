# Rock-Paper-Scissors (Commit-Reveal) – Clarity Smart Contract

This repository contains a **Rock-Paper-Scissors game smart contract** implemented in [Clarity](https://clarity-lang.org/).  
The game uses a **commit–reveal scheme** to ensure fairness and prevent front-running.  

---

## Features

- **Commit–reveal mechanism**: Players commit to their choice with a hash, then reveal later.
- **Explicit STX transfers**: All wagers are handled using `stx-transfer?` for security.
- **Game lifecycle states**:
  - `0` → **CREATED** (waiting for opponent to join)  
  - `1` → **JOINED** (waiting for reveal)  
  - `2` → **FINISHED** (game resolved)  
- **Wager system**: Each game stores wager amounts in micro-STX.
- **Error handling**: Custom error codes for invalid actions, amounts, or states.
- **Choice mapping**: Internal helpers convert between string (`"rock"`, `"paper"`, `"scissors"`) and integer representation.

---

## How It Works

1. **Game Creation**  
   - A player calls `create-game` (not yet shown in snippet, extend as needed) with a wager amount.  
   - The contract transfers STX from the creator into its balance.  

2. **Joining**  
   - Another player joins the game by committing to their choice.  

3. **Reveal Phase**  
   - Both players reveal their choice and salt.  
   - The contract determines the winner using modular arithmetic.  

4. **Settlement**  
   - Wagered STX is transferred to the winner (or split in case of a tie).  

---

## Error Codes

| Constant        | Code   | Meaning                                   |
|-----------------|--------|-------------------------------------------|
| `ERR-NOT-FOUND` | `u100` | Game not found                            |
| `ERR-NOT-CALLER`| `u101` | Action attempted by non-participant        |
| `ERR-BAD-AMOUNT`| `u102` | Incorrect wager amount                    |
| `ERR-BAD-STATE` | `u103` | Invalid game state for action             |
| `ERR-BAD-REVEAL`| `u104` | Reveal did not match committed hash       |
| `ERR-ALREADY`   | `u105` | Player already joined                     |
| `ERR-TRANSFER`  | `u106` | STX transfer failed                       |
| `REVEAL-TIMEOUT`| `u100` | Allowed blocks for reveal after join      |

---

## Getting Started

### Prerequisites
- [Clarinet](https://book.clarity-lang.org/ch01-01-installing-tools.html) (Stacks smart contract development tool)
- [Node.js](https://nodejs.org/) (for Clarinet & testing)

### Clone Repository
```bash
git clone https://github.com/your-username/rock-paper-scissors-clarity.git
cd rock-paper-scissors-clarity
