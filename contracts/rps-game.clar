;; Rock-Paper-Scissors (commit-reveal) - Clarity
;; Author: Generated for Clarinet by ChatGPT
;; Notes:
;;  - All monetary transfers are done explicitly via stx-transfer? during calls.
;;  - Wager amounts are stored per-game as uint (micro-STX units in Clarinet tests).
;;  - Game lifecycle: CREATED (0) -> JOINED (1) -> FINISHED (2)

(define-constant ERR-NOT-FOUND u100)
(define-constant ERR-NOT-CALLER u101)
(define-constant ERR-BAD-AMOUNT u102)
(define-constant ERR-BAD-STATE u103)
(define-constant ERR-BAD-REVEAL u104)
(define-constant ERR-ALREADY u105)
(define-constant ERR-TRANSFER u106)
(define-constant REVEAL-TIMEOUT u100) ;; blocks allowed for reveal after join

(define-map games
  ;; key: game-id (uint)
  ;; value: tuple with game data
  uint
  (tuple
    (creator principal)
    (creator-commit (buff 32))
    (wager uint)
    (joined (optional principal))
    (choice-u (optional int))
    (joined-block (optional uint))
    (created-block uint)
    (state int)))

;; state: 0 = created (waiting join)
;;        1 = joined (waiting reveal)
;;        2 = finished

(define-private (choice->int (c (string-ascii 4)))
  (if (is-eq c "rock")
    (some 0)
    (if (is-eq c "paper")
      (some 1)
      (if (is-eq c "scissors")
        (some 2)
        none))))

(define-private (int->choice (i int))
  (if (is-eq i 0)
    (some "rock")
    (if (is-eq i 1)
      (some "paper")
      (if (is-eq i 2)
        (some "scissors")
        none))))

(define-private (result (a int) (b int))
  ;; returns: 0 tie, 1 a wins, 2 b wins
  (if (is-eq a b)
      0
      (let ((d (mod (- a b) 3)))
        (if (is-eq d 1) 1 2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Create a new game. The caller must have at least 'wager' STX; the contract will
;; call stx-transfer? to move 'wager' from caller into the contract balance.
;; Create a new game. The caller must have at least 'wager' STX; the contract will
;; call stx-transfer? to move 'wager' from caller into the contract balance.
(define-read-only (get-state (game-id uint))
 (match (map-get? games game-id)
  game (ok (get state game))
  (err ERR-NOT-FOUND)
))