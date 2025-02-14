include .env
deploy:
	forge script ./script/DeploySimpleStorage.s.sol --rpc-url ${SEPOLIA_RPC_URL} --broadcast --private-key ${PRIVATE_KEY}

test-fork:
	forge test -vvv --fork-url ${SEPOLIA_RPC_URL}