(use-trait upgradable-fungible-token-logic-trait .upgradable-fungible-token-logic-trait.upgradable-fungible-token-logic-trait)

(define-trait upgradable-fungible-token-trait
  (
    (is-current-implementation (principal) (response bool uint))

    ;; Transfer from the caller to a new principal
    (transfer (uint principal principal <upgradable-fungible-token-logic-trait>) (response bool uint))

    ;; Transfer from the caller to a new principal including a memo
    (transfer-memo (uint principal principal (buff 34) <upgradable-fungible-token-logic-trait>) (response bool uint))

    ;; the human readable name of the token
    (get-name (<upgradable-fungible-token-logic-trait>) (response (string-ascii 32) uint))

    ;; the ticker symbol, or empty if none
    (get-symbol (<upgradable-fungible-token-logic-trait>) (response (string-ascii 32) uint))

    ;; the number of decimals used, e.g. 6 would mean 1_000_000 represents 1 token
    (get-decimals (<upgradable-fungible-token-logic-trait>) (response uint uint))

    ;; the balance of the passed principal
    (get-balance (principal <upgradable-fungible-token-logic-trait>) (response uint uint))

    ;; the current total supply (which does not need to be a constant)
    (get-total-supply (<upgradable-fungible-token-logic-trait>) (response uint uint))

    ;; an optional URI that represents metadata of this token
    (get-token-uri (<upgradable-fungible-token-logic-trait>) (response (optional (string-utf8 256)) uint))
  )
)
