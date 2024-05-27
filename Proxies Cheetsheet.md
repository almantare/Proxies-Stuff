FROM: https://proxies.yacademy.dev/pages/Proxies-List
# Table of Content
- The Proxy
- The initializeable Proxy
- The Upgradeable Proxy
- EIP-1967 Upgradeable Proxy
- Transparent Proxy (TPP)
- Universal Upgradeable Proxy Standard (UUPS)
- Beacon Proxy
- Diamond Proxy
- Metamorphic Contracts
	- Proxy Table
- Proxy Identification Guide
- Storage Collision Vulnerability
- Function Clashing Vulnerability
- Metamorphic Contract Rug Vulnerability
- Delegatecall to Arbitrary Address
- Delegatecall external contract missing existence check
- 
## The Proxy
### Use cases

- Useful when there is a need to deploy multiple contracts whose code is more or less the same.
### Pros
- Inexpensive deployment.
### Cons
- Adds a single `delegatecall` cost to each call.
### Examples
- [Uniswap V1 AMM pools](https://etherscan.io/address/0x09cabec1ead1c0ba254b09efb3ee13841712be14#code)
- [Synthetix](https://github.com/Synthetixio/synthetix/pull/1191)
### Known vulnerabilities
- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
### Variations
- [The EIP-1167 standard](https://eips.ethereum.org/EIPS/eip-1167) was created in June ‘18 with the goal of standardizing a way to clone contract functionality simply, cheaply, and in an immutable way. This standard contains a minimal bytecode redirect implementation that has been optimized for the proxy contract. This is often used with a [factory pattern](https://github.com/optionality/clone-factory).
### Further reading
- [A Minimal Proxy in the Wild](https://blog.originprotocol.com/a-minimal-proxy-in-the-wild-ae3f7b8da990)
- [OpenZeppelin core Proxy contract](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Proxy)
- [Deep dive into the Minimal Proxy contract](https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/)

***
## The Initializeable Proxy
### Use cases

- Most proxies with any kind of storage that needs to be set upon proxy contract deployment.

### Cons
- Susceptible to attacks related to initialization, especially uninitialized proxies.
### Examples

- This feature is used with most modern proxy types including TPP and UUPS, except for use cases where there is no need to set storage upon proxy deployment.
### Known vulnerabilities

- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)

### Variations

- [Clone factory contract model](https://github.com/optionality/clone-factory) - uses clone initialization in a creation transaction.
- [Clones with Immutable Args](https://github.com/wighawag/clones-with-immutable-args) - enables creating clone contracts with immutable arguments which are stored in the code region of the proxy contract. When called, arguments are appended to the calldata of the `delegatecall`, Implementation contract function then reads the arguments from calldata. This pattern can remove the need to use an initializer but the downside is that currently [the contract cannot be verified on Etherscan](https://twitter.com/boredGenius/status/1484713577961250821?s=20&t=5jbuvNruLIJlLRow1nKrMw).

### Further reading

- [Initializeable - OZ](https://docs.openzeppelin.com/contracts/4.x/api/proxy#Initializable)

***
## The Upgradeable Proxy

### Use cases

- A minimalistic upgrade contract. Useful for learning projects.

### Pros

- Reduced deployment costs through use of the [Proxy](https://proxies.yacademy.dev/pages/Proxies-List/#the-proxy).
- Implementation contract is upgradeable.
### Cons

- Prone to storage and function clashing.
- Less secure than modern counterparts.
- Every call incurs cost of `delegatecall` from the [Proxy](https://proxies.yacademy.dev/pages/Proxies-List/#the-proxy).
### Examples

- This basic style is not widely used anymore.

### Known vulnerabilities

- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)
- [Storage collision](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/storage_collision)
- [Function clashing](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/function_clashing)
### Further reading

- [The First Proxy Contract](https://ethereum-blockchain-developer.com/110-upgrade-smart-contracts/05-proxy-nick-johnson/)
- [Writing Upgradeable Contracts](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable)

***
## EIP-1967 Upgradeable Proxy
### Use cases

- When you need more security than the basic [Upgradeable Proxy](https://proxies.yacademy.dev/pages/Proxies-List/#the-upgradeable-proxy).
### Pros

- Reduces risk of storage collisions.
- Block explorer compatibility
### Examples

- While the [EIP-1967](https://eips.ethereum.org/EIPS/eip-1967) storage slot pattern has been widely adopted in most modern upgradeable proxy types, this bare bones contract is not seen in the wild as much as some of the newer patterns like [TPP](https://proxies.yacademy.dev/pages/Proxies-List/#transparent-proxy-tpp), [UUPS](https://proxies.yacademy.dev/pages/Proxies-List/#universal-upgradeable-proxy-standard-uups), and [Beacon](https://proxies.yacademy.dev/pages/Proxies-List/#beacon-proxy).
### Known vulnerabilities

- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)
- [Function clashing](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/function_clashing/UUPS_functionClashing)
### Further reading

- [EIP-1967 Standard Proxy Storage Slots](https://ethereum-blockchain-developer.com/110-upgrade-smart-contracts/09-eip-1967/)
- [The Proxy Delegate](https://fravoll.github.io/solidity-patterns/proxy_delegate.html)
***
## Transparent Proxy (TPP)

### Use cases

- This pattern is very widely used for its upgradeability and protections against certain function and storage collision vulnerabilities.
### Pros

- Eliminates possibility of function clashing for admins, since they are never redirected to the implementation contract.
- Since the upgrade logic lives on the proxy, if a proxy is left in an uninitialized state or if the implementation contract is selfdestructed, then the implementation can still be set to a new address.
- Reduces risk of storage collisions from use of [EIP-1967](https://proxies.yacademy.dev/pages/Proxies-List/#eip-1967-upgradeable-proxy) storage slots.
- Block explorer compatibility.

### Cons

- Every call not only incurs runtime gas cost of `delegatecall` from the [Proxy](https://proxies.yacademy.dev/pages/Proxies-List/#the-proxy) but also incurs cost of SLOAD for checking whether the caller is admin.
- Because the upgrade logic lives on the proxy, there is more bytecode so the deploy costs are higher.
### Examples

- [dYdX](https://github.com/dydxprotocol/perpetual/blob/99962cc62caed2376596da357a13f5c3d0ea5e59/contracts/protocol/PerpetualProxy.sol)
- [USDC](https://github.com/centrehq/centre-tokens/tree/b42cf04b31639b8b05d53fea9995954d5f3659d9/contracts/upgradeability)
- [Aztec](https://github.com/AztecProtocol/AZTEC/blob/cb78ba3ee32ad82234ac0fbed046333eb7f233cf/packages/protocol/contracts/AccountRegistry/AccountRegistryManager.sol#L62-L66)
- [Hundreds of projects on Github](https://github.com/search?q=adminupgradeabilityproxy&type=Code)
### Known vulnerabilities

- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)
- [Storage collision](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/storage_collision)

### Further reading

- [The Transparent Proxy Pattern](https://blog.openzeppelin.com/the-transparent-proxy-pattern/)
***
## Universal Upgradeable Proxy Standard (UUPS)
### Use cases

- These days this is the most widely used pattern when protocols look to deploy upgradeable contracts.
### Pros

- Eliminates risk of functions on the implementation contract colliding with the proxy contract since the upgrade logic lives on the implementation contract and there is no logic on the proxy besides the `fallback()` which delegatecalls to the impl contract.
- Reduced runtime gas over TPP because the proxy does not need to check if the caller is admin.
- Reduced cost of deploying a new proxy because the proxy only contains no logic besides the `fallback()`.
- Reduces risk of storage collisions from use of [EIP-1967](https://proxies.yacademy.dev/pages/Proxies-List/#eip-1967-upgradeable-proxy) storage slots.
- Block explorer compatibility.
### Cons

- Because the upgrade logic lives on the implementation contract, extra care must be taken to ensure the implementation contract cannot `selfdestruct` or get left in a bad state due to an improper initialization. If the impl contract gets borked then the proxy cannot be saved.
- Still incurs cost of `delegatecall` from the [Proxy](https://proxies.yacademy.dev/pages/Proxies-List/#the-proxy).
### Examples

- [Superfluid](https://github.com/superfluid-finance/protocol-monorepo)
- [Synthetix](https://github.com/Synthetixio/synthetix-v3)
- [Hundreds of projects on Github](https://github.com/search?q=UUPSUpgradeable&type=code)
### Known vulnerabilities

- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)
- [Function clashing](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/function_clashing)
- [Selfdestruct](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
### Further reading

- [EIP-1822](https://eips.ethereum.org/EIPS/eip-1822)
- [Using UUPS Proxy Pattern](https://blog.logrocket.com/using-uups-proxy-pattern-upgrade-smart-contracts/)
- [Perma-brick UUPS proxies with this one trick](https://iosiro.com/blog/openzeppelin-uups-proxy-vulnerability-disclosure)

***
## Beacon Proxy
### Use cases

- If you have a need for multiple proxy contracts that can all be upgraded at once by upgrading the beacon.
- Appropriate for situations that involve large amounts of proxy contracts based on multiple implementation contracts. The beacon proxy pattern enables updating various groups of proxies at the same time.
### Pros

- Easier to upgrade multiple proxy contracts at the same time.
### Cons

- Gas overhead of getting the beacon contract address from storage, calling beacon contract, and then getting the implementation contract address from storage, plus the extra gas required by using a proxy.
- Adds additional complexity.
### Examples

- [USDC](https://polygonscan.com/address/0xb254554636a3ff52e8b2d0f06203921c137e10d5#code)
- [Dharma](https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol)
### Known vulnerabilities

- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
- [Uninitialized proxy](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/uninitialized/UUPS_Uninitialized)
- [Function clashing](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/function_clashing)
### Variations

- Immutable Beacon address - To save gas, the beacon address can be made immutable in the proxy contract. The implementation contract would still be settable by updating it on the beacon.
- [Storageless Upgradeable Beacon Proxy](https://forum.openzeppelin.com/t/a-more-gas-efficient-upgradeable-proxy-by-not-using-storage/4111) - In this pattern, the beacon contract does not store the implementation contract address in storage, but instead stores it in code. The proxy contract loads it from the beacon directly via `EXTCODECOPY`.
### Further reading

- [How to create a Beacon Proxy](https://medium.com/coinmonks/how-to-create-a-beacon-proxy-3d55335f7353)
- [Dharma](https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol)
***
## Diamond Proxy
### Use cases

- A complex system where the highest level of upgradeability and modular interoperability is required.
### Pros

- A stable contract address that provides needed functionality. Emitting events from a single address can simplify event handling.
- Can be used to break up a large contract > 24kb that is over the Spurious Dragon limit.
### Cons

- Additional gas required to access storage when routing functions.
- Increased chance of storage collision due to complexity.
- Complexity may be too much when simple upgradeability is required.
### Examples

- [Simple DeFi](https://www.simpledefi.io/)
- [PartyFinance](https://party.finance/)
- [Complete list of examples](https://github.com/mudgen/awesome-diamonds#projects-using-diamonds).
### Known vulnerabilities

- [Delegatecall and selfdestruct not allowed in implementation](https://github.com/YAcademy-Residents/Solidity-Proxy-Playground/tree/main/src/delegatecall_with_selfdestruct/UUPS_selfdestruct)
### Variations

- [vtable](https://github.com/OpenZeppelin/openzeppelin-labs/tree/master/upgradeability_with_vtable)
- [How to build unlimited size contracts](https://twitter.com/ylv_io/status/1581639395064836102?s=20&t=WoHhqaSl8SlEdLUje5Cziw)
### Further reading

- [Answering some Diamond questions](https://eip2535diamonds.substack.com/p/answering-some-diamond-questions)
- [Dark Forest and the Diamond standard](https://blog.zkga.me/dark-forest-and-the-diamond-standard)
- [Good idea, bad design. How the Diamond standard falls short](https://blog.trailofbits.com/2020/10/30/good-idea-bad-design-how-the-diamond-standard-falls-short/)
- [Addressing Josselin Feist’s Concern’s of EIP-2535 Diamonds](https://dev.to/mudgen/addressing-josselin-feist-s-concern-s-of-eip-2535-diamond-standard-me8)
## Metamorphic Contracts
### Use cases

- Contracts that contain only logic (similar to Solidity external libraries).
- Contracts with little state that changes infrequently, such as beacons.
### Pros

- Does not require the use of a proxy with `delegatecall`.
- Does not require using an `initialize()` instead of a `constructor()`.
### Cons

- Storage is erased on upgrade because of `selfdestruct`.
- Because `selfdestruct` clears the code at the end of the transaction, an upgrade requires two transactions: one to delete the current contract, and another to create the new one. Any transaction that arrives to our contract in between those two would fail.
- The `selfdestruct` opcode may be removed in the future.
### Examples

- [Example contracts from 0age](https://github.com/0age/metamorphic#metamorphic).
- This is more of an experimental type. Mostly used by MEV searchers (etherscan examples [here](https://etherscan.io/address/0x0000000000007f150bd6f54c40a34d7c3d5e9f56#code) and [here](https://etherscan.io/address/0x000000005736775feb0c8568e7dee77222a26880#code)).
### Known vulnerabilities

- Not vulnerable to the typical upgradeable proxy vulnerabilities since it doesn’t use a proxy or an initializer.
- May be vulnerable to attack at time of upgrade.
### Further reading

- [Metamorphosis Smart Contracts using CREATE2](https://ethereum-blockchain-developer.com/110-upgrade-smart-contracts/12-metamorphosis-create2/)
- [The Promise and the Peril of Metamorphic Contracts](https://0age.medium.com/the-promise-and-the-peril-of-metamorphic-contracts-9eb8b8413c5e)
- [a16z Metamorphic Contract Detector Tool](https://a16zcrypto.com/metamorphic-smart-contract-detector-tool/)

***
# Proxies Table

| Type                                                  | Summary                                                                                                                                                                                                                                                                                                                                                                                      | Pros                                                                                                                      | Cons                                                                                                                                                                             | Gotchas                                                                                                                                                                                       | Who should implement                                                                                                                                                              | Known Vulnerabilities                                                                                                                                                  | Upgradeable? | Can be made immutable?                                                                                |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | ----------------------------------------------------------------------------------------------------- |
| Proxy                                                 | Calls made to the proxy contract are forwarded to the implementation contract using `delegatecall`. Address of the implementation contract is immutable in the proxy. This is the basis for just about all proxy types with the exception of Metamorphic. One example of this proxy type is EIP1167 Minimal Proxy Clones. An improvement over Minimal Proxy Clones is Clones with Immutables | Simple                                                                                                                    | Costs gas to do the delegate call                                                                                                                                                |                                                                                                                                                                                               | Shims to avoid deploying many of the same contract and can deploy new shims that point to an existing contract. When there’s a 1-1 relationship between proxy and impl contracts. | delegatecall in implementation or selfdestruct in implementation                                                                                                       | No           | Yes, by design.                                                                                       |
| Upgradeable Proxy                                     | Similar to proxy except the address of the impl contract is kept in storage in the proxy. Permissioned upgrade logic is also located in the proxy.                                                                                                                                                                                                                                           | Simple.                                                                                                                   | Extra care is required for the upgrade logic (access control) as it resides in the implementation contract. Costs gas to do the delegate call, Vulnerable to function collisions | Storage collisions can be avoided by EIP1967, admin != caller                                                                                                                                 | Not widely used anymore. There are better patterns.                                                                                                                               | Function collision with proxy, storage collision, delegatecall in implementation, or selfdestruct in implementation                                                    | Yes          | Yes, by admin revoking ownership of the proxy.                                                        |
| Transparent Proxy (TPP)                               | Similar to Upgradeable proxy for non-admin callers, but when the admin calls the proxy the proxy’s functions are used                                                                                                                                                                                                                                                                        | Comparatively easy and simpler to implement; widely used                                                                  | Waste gas on delegatecall and checking storage to see if caller is admin                                                                                                         | Storage collisions can be avoided by EIP1967 , admin != caller, using a UUPS compliant implementation with a TransparentUpgradeableProxy might allow non-admins to perform upgrade operations | Still used for its simplicity especially when there is a 1:1 relationship between the proxy and impl contracts.                                                                   | function collision with proxy, delegatecall in implementation, or selfdestruct in implementation, storage slot collision with proxy, uninitialize proxies, gas guzzler | Yes          | Yes, by admin revoking ownership of the proxy.                                                        |
| Universal Upgradeable Proxy Standard (UUPS) - EIP1822 | Similar to Transparent proxy except the `upgrade` logic is stored in the implementation contract so there is no need to check if the caller is admin in the proxy (saving gas). UUPS proxies also contain a check to ensure the new impl contract is also upgradeable.                                                                                                                       | More gas efficient. Reduces function conflicts w proxy since upgrade fns are in impl.                                     | Still have overhead of delegate call                                                                                                                                             | Storage collisions can be avoided by EIP1967 , admin != caller                                                                                                                                | For a more gas efficient proxy and when there are many different proxy contracts pointing to the same implementation.                                                             | delegatecall in implementation, or selfdestruct in implementation, uninitialized proxy                                                                                 | Yes          | Yes by admin revoking ownership or by upgrading to an impl contract that does not contain impl logic. |
| Beacon Proxy (aka Dharma Beacon Proxy)                | Instead of storing the impl contract address the proxy stores the address of a beacon. The beacon contract stores the address of the implementation contract.                                                                                                                                                                                                                                | Can upgrade many different proxies pointing to the beacon.                                                                | Gas overhead of calling Beacon contract and getting the impl contract address from storage, as well as the delegate call                                                         | Storage collisions can be avoided by EIP1967, admin != caller                                                                                                                                 | When more control is desired with more complex systems of upgradeability. Sets of proxies can point to one beacon while other types can point to a different beacon.              | delegatecall in implementation, or selfdestruct in implementation, uninitialized proxy                                                                                 | Yes          | Technically yes, but if the goal was immutability then choose a different type.                       |
| Upgradeable Beacon Proxy                              | Same as Dharma Beacon proxy except the Beacon address is settable in the proxy.                                                                                                                                                                                                                                                                                                              | Even the Beacon contract can be upgraded.                                                                                 | Complex. Gas guzzler.                                                                                                                                                            | Storage collisions can be avoided by EIP1967 , admin != caller                                                                                                                                | Even more complex patterns can be used when the beacon address is also upgradable.                                                                                                | delegatecall in implementation, or selfdestruct in implementation, uninitialized proxy                                                                                 | Yes          | Technically yes, but if the goal was immutability then choose a different type.                       |
| Storageless Upgradeable Beacon Proxy                  | The Beacon contract stores the implementation contract in the code instead of in storage, saving gas. https://forum.openzeppelin.com/t/a-more-gas-efficient-upgradeable-proxy-by-not-using-storage/4111                                                                                                                                                                                      | More gas efficient than TPP, UUPS, Dharma Beacon                                                                          | Complexity. Little to no adoption.                                                                                                                                               | The upgrade process involves self-destructing the beacon so there is a 1 block down time for the beacon. As such a backup beacon is utilized.                                                 | This is more of an experiment and there are no known implementations of this in the wild.                                                                                         | delegatecall in implementation, or selfdestruct in implementation, uninitialized proxy                                                                                 | Yes          | Technically yes, but if the goal was immutability then choose a different type.                       |
| Diamond Proxy                                         | An upgradeable proxy pattern in which there are multiple logic contracts (instead of just one) called facets. Additionally, this pattern uses a separate contract for storage.                                                                                                                                                                                                               | Can create powerful, modular combinations. Helps to battle the 24KB size limit via modularity; incremental upgradeability | Complexity. Slow adoption.                                                                                                                                                       | More complex to implement and maintain; uses new terminologies that can be harder for newcomers to understand; as of this writing, not supported by tools like Etherscan                      | When you need the control and flexibility offered by having multiple logic contracts or separate storage.                                                                         | delegatecall in implementation, or selfdestruct in implementation, uninitialized proxy                                                                                 | Yes          | Yes                                                                                                   |
| Metamorphic Contract                                  | A contract that is deployed with CREATE2 and in the constructor, it retrieves the address for the contract code from the storage of an external registry contract. To upgrade, the contract is selfdestructed.                                                                                                                                                                               | No delegatecall so this is the most gas efficient.                                                                        | Complex, little adoption in the wild.                                                                                                                                            | The selfdestruct opcode may be removed in the future.                                                                                                                                         | Optimizooors, those who like living on the edge.                                                                                                                                  | ?                                                                                                                                                                      | Yes          | Yes, by removing self destruct from the upgrade.                                                      |

***
# Proxy Identification Guide

## Basic delegatecall Proxy Identifiers

- Does not need to follow EIP-1967. The proxy may instead use a regular storage variable to store the external contract address used with `delegatecall`.
- May use [EIP-1167](https://eips.ethereum.org/EIPS/eip-1167) minimal proxy bytecode. The bytecode for the Uniswap V1 proxy is `0x3660006000376110006000366000732157a7894439191e520825fe9399ab8655e0f7085af41558576110006000f3`. For example, see contract [0xa2881a90bf33f03e7a3f803765cd2ed5c8928dfb](https://etherscan.io/address/0xa2881a90bf33f03e7a3f803765cd2ed5c8928dfb#code).

## Transparent Proxy (TPP) Identifiers

- The proxy contract fallback function will act differently if the admin (or similar privileged role) calls the contract, so look for an if statement in the proxy contract that checks if msg.sender is the admin. One example of a modifier to do this check is [in the OpenZeppelin library](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/transparent/TransparentUpgradeableProxy.sol#L45-L51).
- The proxy contract often has an upgrade function and a function to change the address of the proxy admin. These functions should be protected with an access control modifier.

## UUPS Proxy Identifiers

- Normally imports a contract with the letters “UUPS” [from OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/utils/UUPSUpgradeable.sol) or a similar library.
- Contains an initialize function
- May include the number 1822 in a comment of the contract or an imported contract (from [EIP-1822](https://eips.ethereum.org/EIPS/eip-1822), the UUPS EIP).

## Metamorphic Contract Identifiers

- Contains `selfdestruct` (or `delegatecall` to call `selfdestruct` in another contract) to allow the existing code to be removed and replaced by another contract that will be deployed at the same address.
- Often does not have a `delegatecall`
- Contract was created with CREATE2 from another contract, not an EOA. You can find the creation transaction on etherscan (manually in the “Contract Creator” information field of etherscan or automatically with [the etherscan API](https://docs.etherscan.io/api-endpoints/contracts#get-contract-creator-and-creation-tx-hash)).

## Diamond Proxy Identifiers

- Most likely has contract names that include the words “diamond”, “facet”, “loupe”.
- Per the [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) spec, the IDiamondLoupe interface must be implemented with these four functions: `facets()`, `facetFunctionSelectors(address _facet)`, `facetAddresses()`, `facetAddress(bytes4 _functionSelector)`
- The function which contains `delegatecall` will allow the user to specify an argument to identify the facet that should be called by delegatecall. This argument specifying the facet may not necessarily be a function argument but could, for example, be `msg.data`.

***
## [](https://proxies.yacademy.dev/pages/Security-Guide/#storage-collision-vulnerability)Storage Collision Vulnerability

## [](https://proxies.yacademy.dev/pages/Security-Guide/#function-clashing-vulnerability)Function Clashing Vulnerability

## [](https://proxies.yacademy.dev/pages/Security-Guide/#metamorphic-contract-rug-vulnerability)Metamorphic Contract Rug Vulnerability

## [](https://proxies.yacademy.dev/pages/Security-Guide/#delegatecall-to-arbitrary-address)Delegatecall to Arbitrary Address

## [](https://proxies.yacademy.dev/pages/Security-Guide/#delegatecall-external-contract-missing-existence-check)Delegatecall external contract missing existence check