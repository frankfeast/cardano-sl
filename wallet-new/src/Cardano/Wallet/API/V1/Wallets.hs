module Cardano.Wallet.API.V1.Wallets where

import           Universum

import           Cardano.Wallet.API.Types
import           Cardano.Wallet.API.V1.Parameters
import           Cardano.Wallet.API.V1.Types

import           Servant

type API =
         "wallets" :> Summary "Creates a new Wallet."
                   :> ReqBody '[JSON] Wallet
                   :> Post '[JSON] Wallet
    :<|> "wallets" :> Summary "Returns all the available wallets."
                   :> WalletRequestParams
                   :> Get '[JSON] (OneOf [Wallet] (ExtendedResponse [Wallet]))
    :<|> "wallets" :> Capture "walletId" WalletId
                   :> ( "accounts" :> Header  "Daedalus-Passphrase" Text
                                   :> Summary "Creates a new Account for the given Wallet."
                                   :> ReqBody '[JSON] Account
                                   :> Post '[JSON] Account
                   )