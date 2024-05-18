(impl-trait .upgradable-fungible-token-logic-trait.upgradable-fungible-token-logic-trait)

(define-constant err-unauthorised (err u200))
(define-constant err-no-price (err u201))
(define-constant err-paused (err u202))

;; upgradable-token-logic-trait implementation

(define-public (transfer (amount uint) (sender principal) (recipient principal) (original-caller principal))
	(begin
		(asserts! (not (is-paused)) err-paused)
		(asserts! (or (is-eq sender tx-sender) (is-eq sender original-caller)) err-unauthorised)
		(contract-call? .upgradable-fungible-token impl-transfer amount sender recipient)
	)
)

(define-public (transfer-memo (amount uint) (sender principal) (recipient principal) (memo (buff 34)) (original-caller principal))
	(begin
		(asserts! (not (is-paused)) err-paused)
		(asserts! (or (is-eq sender tx-sender) (is-eq sender original-caller)) err-unauthorised)
		(print memo)
		(contract-call? .upgradable-fungible-token impl-transfer amount sender recipient)
	)
)

(define-public (get-name)
	(ok (default-to "" (get-string-32? "name")))
)

(define-public (get-symbol)
	(ok (default-to "" (get-string-32? "symbol")))
)

(define-public (get-decimals)
	(ok (default-to u0 (get-uint? "decimals")))
)

(define-public (get-balance (who principal))
	(ok (contract-call? .upgradable-fungible-token impl-get-balance who))
)

(define-public (get-total-supply)
	(ok (contract-call? .upgradable-fungible-token impl-get-total-supply))
)

(define-public (get-token-uri)
	(ok (get-string-utf8-256? "token-uri"))
)

;; functions to read data from storage

(define-private (is-paused)
	(default-to false (from-consensus-buff? bool (unwrap! (contract-call? .upgradable-fungible-token get-data "paused") false)))
)

(define-private (get-string-32? (key (string-ascii 16)))
	(from-consensus-buff? (string-ascii 32) (try! (contract-call? .upgradable-fungible-token get-data key)))
)

(define-private (get-string-utf8-256? (key (string-ascii 16)))
	(from-consensus-buff? (string-utf8 256) (try! (contract-call? .upgradable-fungible-token get-data key)))
)

(define-private (get-uint? (key (string-ascii 16)))
	(from-consensus-buff? uint (try! (contract-call? .upgradable-fungible-token get-data key)))
)

;; some kind of mechanism to mint and burn tokens, depends on token project

(define-public (buy-tokens (amount uint))
	(let ((price (unwrap! (get-uint? "price") err-no-price)))
		(asserts! (not (is-paused)) err-paused)
		(try! (stx-transfer? (* amount price) tx-sender (contract-call? .upgradable-fungible-token get-contract-owner)))
		(contract-call? .upgradable-fungible-token impl-mint amount tx-sender)
	)
)

(define-public (owner-set-price-per-token (price uint))
	(begin
		(try! (contract-call? .upgradable-fungible-token is-contract-owner contract-caller))
		(contract-call? .upgradable-fungible-token set-data "price" (unwrap-panic (to-consensus-buff? price)))
	)
)

(define-public (owner-burn (amount uint) (who principal))
	(begin
		(try! (contract-call? .upgradable-fungible-token is-contract-owner contract-caller))
		(contract-call? .upgradable-fungible-token impl-burn amount who)
	)
)

(define-public (owner-set-paused (paused bool))
	(begin
		(try! (contract-call? .upgradable-fungible-token is-contract-owner contract-caller))
		(contract-call? .upgradable-fungible-token set-data "paused" (unwrap-panic (to-consensus-buff? paused)))
	)
)
