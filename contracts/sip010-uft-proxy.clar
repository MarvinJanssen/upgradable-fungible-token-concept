;; These proxies create a SIP010 interface for UFTs. A new one should be deployed
;; each time the implementation is upgraded.
;; However, using the proxy brings limitations. (contract-caller check cannot succeed in the UFT).

(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(match memo
		to-print (contract-call? .upgradable-fungible-token transfer-memo amount sender recipient to-print .upgradable-fungible-token-impl)
		(contract-call? .upgradable-fungible-token transfer amount sender recipient .upgradable-fungible-token-impl)
	)
)

(define-public (get-name)
	(contract-call? .upgradable-fungible-token get-name .upgradable-fungible-token-impl)
)

(define-public (get-symbol)
	(contract-call? .upgradable-fungible-token get-symbol .upgradable-fungible-token-impl)
)

(define-public (get-decimals)
	(contract-call? .upgradable-fungible-token get-decimals .upgradable-fungible-token-impl)
)

(define-public (get-balance (who principal))
	(contract-call? .upgradable-fungible-token get-balance who .upgradable-fungible-token-impl)
)

(define-public (get-total-supply)
	(contract-call? .upgradable-fungible-token get-total-supply .upgradable-fungible-token-impl)
)

(define-public (get-token-uri)
	(contract-call? .upgradable-fungible-token get-token-uri .upgradable-fungible-token-impl)
)
