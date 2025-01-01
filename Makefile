# Use Bash for all shell commands
SHELL := /bin/bash

# Foundry Commands
FORGE=forge

# Default EVM Version
EVM_VERSION=cancun

# Ensure the .env file exists
ENV_FILE=.env

# Targets
.PHONY: setup airdropandapprove bridgetol2 bridgetol1 build

# Add setup target
setup:
	@echo "Installing dependencies and building project..."
	@git submodule update --init --recursive
	@$(FORGE) install --no-commit
	@$(FORGE) build

# Modify Step 1: Airdrop and Approve on L1
airdropandapprove: | setup
	@echo "Running Airdrop and Approve Script on L1..."
	@test -f $(ENV_FILE) || (echo "$(ENV_FILE) not found!" && exit 1)
	@set -a; source $(ENV_FILE); \
	$(FORGE) script script/AirdropAndApprove.s.sol \
		--rpc-url $$L1_RPC \
		--private-key $$TEST_PRIVATE_KEY \
		--broadcast \
		--evm-version $(EVM_VERSION)

# Modify Step 2: Bridge to L2
bridgetol2: | setup
	@echo "Running BridgeToL2 Script..."
	@test -f $(ENV_FILE) || (echo "$(ENV_FILE) not found!" && exit 1)
	@set -a; source $(ENV_FILE); \
	$(FORGE) script script/BridgeToL2.s.sol \
		--rpc-url $$L1_RPC \
		--private-key $$TEST_PRIVATE_KEY \
		--broadcast \
		--evm-version $(EVM_VERSION)

# Modify Step 3: Bridge to L1
bridgetol1: | setup
	@echo "Running BridgeToL1 Script..."
	@test -f $(ENV_FILE) || (echo "$(ENV_FILE) not found!" && exit 1)
	@set -a; source $(ENV_FILE); \
	$(FORGE) script script/BridgeToL1.s.sol \
		--rpc-url $$L2_RPC \
		--private-key $$TEST_PRIVATE_KEY \
		--broadcast \
		--evm-version $(EVM_VERSION)
