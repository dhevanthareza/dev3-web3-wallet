import 'package:dev3_wallet/entity/chain_entity.dart';

final List<ChainEntity> DEFAULT_CHAINS = [
  ChainEntity(
    name: "Ethereum",
    rpcUrl: "https://eth.llamarpc.com",
    symbol: "ETH",
    tokens: [],
    chainId: "1",
  ),
  ChainEntity(
    name: "Arbitrum One",
    rpcUrl: "https://arb-mainnet-public.unifra.io",
    symbol: "ETH",
    tokens: [],
    chainId: "42161",
  ),
  ChainEntity(
    name: "zkSync Era",
    rpcUrl: "https://mainnet.era.zksync.io",
    symbol: "ETH",
    tokens: [],
    chainId: "324",
  ),
  ChainEntity(
    name: "Binance Smart Chain",
    rpcUrl: "https://bsc-dataseed4.defibit.io",
    symbol: "BNB",
    tokens: [],
    chainId: "56",
  ),
  ChainEntity(
    name: "Polygon",
    rpcUrl: "https://polygon-bor.publicnode.com",
    symbol: "MATIC",
    tokens: [],
    chainId: "137",
  ),
  ChainEntity(
    name: "Mumbai Testnet",
    rpcUrl: "https://polygon-mumbai-bor.publicnode.com",
    symbol: "MATIC",
    tokens: [],
    chainId: "80001",
  ),
];
