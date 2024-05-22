(impl-trait .upgradable-fungible-token-trait.upgradable-fungible-token-trait)
(use-trait upgradable-fungible-token-impl-trait .upgradable-fungible-token-impl-trait.upgradable-fungible-token-impl-trait)
(use-trait sip-010-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-fungible-token upgradable-token)

(define-data-var contract-owner principal tx-sender)
(define-data-var current-logic-implementation principal tx-sender)
(define-data-var current-proxy (optional principal) none)

(define-constant err-not-current-implementation (err u100))
(define-constant err-not-owner (err u101))

(define-map data-storage (string-ascii 16) (buff 2048))
(map-set data-storage "name" (unwrap-panic (to-consensus-buff? "Upgradable Fungible Token")))
(map-set data-storage "symbol" (unwrap-panic (to-consensus-buff? "UFT")))
(map-set data-storage "decimals" (unwrap-panic (to-consensus-buff? u6)))

;; upgradable-fungible-token-trait implementation

(define-read-only (get-current-implementation)
	(ok (var-get current-logic-implementation))
)

(define-read-only (get-current-proxy)
	(ok (var-get current-proxy))
)

(define-read-only (is-current-implementation (implementation principal))
	(ok (asserts! (is-eq implementation (var-get current-logic-implementation)) err-not-current-implementation))
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation transfer amount sender recipient contract-caller)
	)
)

(define-public (transfer-memo (amount uint) (sender principal) (recipient principal) (memo (buff 34)) (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation transfer-memo amount sender recipient memo contract-caller)
	)
)

(define-public (get-name (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-name)
	)
)

(define-public (get-symbol (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-symbol)
	)
)

(define-public (get-decimals (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-decimals)
	)
)

(define-public (get-balance (who principal) (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-balance who)
	)
)

(define-public (get-total-supply (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-total-supply)
	)
)

(define-public (get-token-uri (implementation <upgradable-fungible-token-impl-trait>))
	(begin
		(try! (is-current-implementation (contract-of implementation)))
		(contract-call? implementation get-token-uri)
	)
)

;; some kind of governance to trigger upgrades

(define-read-only (get-contract-owner)
	(var-get contract-owner)
)

(define-read-only (is-contract-owner (who principal))
	(ok (asserts! (is-eq who (var-get contract-owner)) err-not-owner))
)

(define-public (set-contract-owner (new-owner principal))
	(begin
		(try! (is-contract-owner contract-caller))
		(ok (var-set contract-owner new-owner))
	)
)

(define-public (upgrade (new-implementation <upgradable-fungible-token-impl-trait>) (new-proxy (optional <sip-010-trait>)))
	(begin
		(try! (is-contract-owner contract-caller))
		(var-set current-proxy (match new-proxy trait-ref (some (contract-of trait-ref)) none))
		(ok (var-set current-logic-implementation (contract-of new-implementation)))
	)
)

;; implementation functions to affect contract storage

(define-read-only (get-data (key (string-ascii 16)))
	(map-get? data-storage key)
)

(define-public (set-data (key (string-ascii 16)) (value (buff 2048)))
	(begin
		(try! (is-current-implementation contract-caller))
		(ok (map-set data-storage key value))
	)
)

(define-public (impl-transfer (amount uint) (sender principal) (recipient principal))
	(begin
		(try! (is-current-implementation contract-caller))
		(ft-transfer? upgradable-token amount sender recipient)
	)
)

(define-read-only (impl-get-balance (who principal))
	(ft-get-balance upgradable-token who)
)

(define-read-only (impl-get-total-supply)
	(ft-get-supply upgradable-token)
)

(define-public (impl-mint (amount uint) (who principal))
	(begin
		(try! (is-current-implementation contract-caller))
		(ft-mint? upgradable-token amount who)
	)
)

(define-public (impl-burn (amount uint) (who principal))
	(begin
		(try! (is-current-implementation contract-caller))
		(ft-burn? upgradable-token amount who)
	)
)
