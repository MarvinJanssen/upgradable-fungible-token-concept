# Upgradable fungible token standard

To try it out in `clarinet console`:

```clarity
;; Activate the token by performing initial upgrade
(contract-call? .upgradable-fungible-token upgrade .upgradable-fungible-token-logic)

;; Implementation detail, set some token price
(contract-call? .upgradable-fungible-token-logic owner-set-price-per-token u23)

;; Switch to some user
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5

;; User buys some tokens
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token-logic buy-tokens u100)

;; User transfers some tokens
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token transfer-memo u20 tx-sender 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0 0x112233 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token-logic)

;; Switch back to contract owner
::set_tx_sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM

;; Upgrade to an implementation with pause feature
(contract-call? .upgradable-fungible-token upgrade .upgradable-fungible-token-logic-pausing)

;; Pause the token
(contract-call? .upgradable-fungible-token-logic-pausing owner-set-paused true)

;; Switch to some user
::set_tx_sender ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5

;; User transfers some tokens, trying to use old implementation
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token transfer-memo u20 tx-sender 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0 0x112233 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token-logic)

;; User transfers some tokens using current implementation
(contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token transfer-memo u20 tx-sender 'ST3AM1A56AK2C1XAFJ4115ZSV26EB49BVQ10MGCS0 0x112233 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.upgradable-fungible-token-logic-pausing)
```