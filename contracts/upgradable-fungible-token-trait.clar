(use-trait upgradable-fungible-token-impl-trait .upgradable-fungible-token-impl-trait.upgradable-fungible-token-impl-trait)

(define-trait upgradable-fungible-token-trait
  (
    (get-current-implementation () (response principal bool))
    (get-current-proxy () (response (optional principal) uint))
    
    (is-current-implementation (principal) (response bool uint))

    ;; Transfer from the caller to a new principal
    (transfer (uint principal principal <upgradable-fungible-token-impl-trait>) (response bool uint))

    ;; Transfer from the caller to a new principal including a memo
    (transfer-memo (uint principal principal (buff 34) <upgradable-fungible-token-impl-trait>) (response bool uint))

    ;; the human readable name of the token
    (get-name (<upgradable-fungible-token-impl-trait>) (response (string-ascii 32) uint))

    ;; the ticker symbol, or empty if none
    (get-symbol (<upgradable-fungible-token-impl-trait>) (response (string-ascii 32) uint))

    ;; the number of decimals used, e.g. 6 would mean 1_000_000 represents 1 token
    (get-decimals (<upgradable-fungible-token-impl-trait>) (response uint uint))

    ;; the balance of the passed principal
    (get-balance (principal <upgradable-fungible-token-impl-trait>) (response uint uint))

    ;; the current total supply (which does not need to be a constant)
    (get-total-supply (<upgradable-fungible-token-impl-trait>) (response uint uint))

    ;; an optional URI that represents metadata of this token
    (get-token-uri (<upgradable-fungible-token-impl-trait>) (response (optional (string-utf8 256)) uint))
  )
)
