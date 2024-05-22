(use-trait upgradable-fungible-token-trait .upgradable-fungible-token-trait.upgradable-fungible-token-trait)
(use-trait upgradable-fungible-token-impl-trait .upgradable-fungible-token-impl-trait.upgradable-fungible-token-impl-trait)
(use-trait sip-010-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-public (swap-x-for-y-sip010
	(amount-x uint)
	(token-x <sip-010-trait>)
	(token-y <sip-010-trait>)
	(min-amount-y uint)
	)
	(begin
		(try! (contract-call? token-x transfer amount-x tx-sender (as-contract tx-sender) none))
		(contract-call? token-y transfer min-amount-y (as-contract tx-sender) tx-sender none)
	)
)

(define-public (swap-x-for-y-uft
	(amount-x uint)
	(token-x <upgradable-fungible-token-trait>)
	(token-x-impl <upgradable-fungible-token-impl-trait>)
	(token-y <upgradable-fungible-token-trait>)
	(token-y-impl <upgradable-fungible-token-impl-trait>)
	(min-amount-y uint)
	)
	(begin
		(try! (contract-call? token-x transfer amount-x tx-sender (as-contract tx-sender) token-x-impl))
		(contract-call? token-y transfer min-amount-y (as-contract tx-sender) tx-sender token-y-impl)
	)
)