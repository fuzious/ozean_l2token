# OzeanAsset Bridging Workflow

This repository provides a demonstration of how to **airdrop and approve** tokens on L1 (Sepolia), then **bridge** them over to Ozean’s L2, and finally **bridge back** from L2 to L1.  

Below is a step-by-step guide to using Makefile-based workflow, environment configuration, and deployment scripts.

---

## Relevant Addresses

- **L1 Token**: [0xD613E5a92Feb45A3c8a7461218EFE94988464639](https://sepolia.etherscan.io/address/0xD613E5a92Feb45A3c8a7461218EFE94988464639)
- **L2 Token**: [0x2FFF8da8ac5274CDB5f07E1546A6346402490A8E](https://ozean-testnet.explorer.caldera.xyz/address/0x2FFF8da8ac5274CDB5f07E1546A6346402490A8E)

---

## Prerequisites

1. **Sepolia (L1) Test ETH**:  
   You need sufficient ETH on Sepolia for gas fees when minting, approving, and bridging.

2. **Ozean (L2) Native Currency**:  
   You need enough native tokens (**USDX on Ozean’s L2**) to cover gas fees on L2 when bridging back.

3. **Forge & Foundry**:  
   - Install [Foundry](https://book.getfoundry.sh/getting-started/installation) on your local machine.  
   - Make sure `forge --version` works in your terminal.

4. **Environment File**:  
   The `.env` file in this repository should contain the following variables:

Sample ENV
   ```bash
    L1_BRIDGE_ADDRESS=0xb9558CE3C11EC69e18632A8e5B316581e852dB91
    L2_BRIDGE_ADDRESS=0x4200000000000000000000000000000000000010
    L1_TOKEN_ADDRESS=0xD613E5a92Feb45A3c8a7461218EFE94988464639
    L2_TOKEN_ADDRESS=0x2FFF8da8ac5274CDB5f07E1546A6346402490A8E
    BRIDGE_AMOUNT=1000000000000000000 # 1 token (adjust as needed)
    L1_RPC=
    L2_RPC=https://ozean-testnet.rpc.caldera.xyz/http
    TEST_PRIVATE_KEY=
    TOKEN_NAME_L1=OzeanAsset
    TOKEN_NAME_L2=OzeanAssetL2
    TOKEN_SYMBOL=OZA
   ```

   > **Note**: `TEST_PRIVATE_KEY` should have enough Sepolia ETH on L1 and USDX on Ozean L2 balance for gas.

---

## High-Level Workflow

1. **Airdrop & Approve (on L1)**  
   - Mint tokens on the L1 token contract to your address.  
   - Approve the L1 bridge contract to spend your newly minted tokens.

2. **Bridge from L1 to L2**  
   - Use the L1 bridge to lock (or burn) tokens on Sepolia.  
   - Once finalized, the L2 token contract mints tokens for you on Ozean L2.  
   - Wait until the bridging transaction has confirmed/finalized before proceeding.

3. **Bridge from L2 back to L1**  
   - Use the L2 bridge to burn your tokens on Ozean L2.  
   - After the withdrawal is finalized on L1, you receive the unlocked tokens back on Sepolia.  
   - Ensure you allow enough time for the L2 → L1 transaction to finalize.

---

## Quick Start
```bash
# 1. Clone and setup
cp .env.example .env    # Fill in your details

# 2. Run the complete bridging flow
make airdropandapprove  # Airdrop & approve test tokens on L1
make bridgetol2         # Bridge tokens to L2 (wait for confirmation and receiving token on l2 before proceeding)
make bridgetol1         # Bridge back to L1 (wait for finalization)
```
