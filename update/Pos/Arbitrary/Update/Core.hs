-- | Arbitrary instances for Update System core types.

module Pos.Arbitrary.Update.Core
       (
       ) where

import           Universum

import qualified Data.HashMap.Strict as HM
import           Test.QuickCheck (Arbitrary (..), listOf1, oneof)
import           Test.QuickCheck.Arbitrary.Generic (genericArbitrary, genericShrink)

import           Pos.Arbitrary.Core ()
import           Pos.Arbitrary.Crypto ()
import           Pos.Arbitrary.Slotting ()
import           Pos.Binary.Update ()
import           Pos.Core.Update (BlockVersionModifier, SystemTag (..), UpdateData (..),
                                  UpdatePayload (..), UpdateProposal (..),
                                  UpdateProposalToSign (..), UpdateVote (..),
                                  mkUpdateProposalWSign, mkUpdateVote)
import           Pos.Crypto (ProtocolMagic, fakeSigner)
import           Pos.Data.Attributes (mkAttributes)
import           Pos.Update.Poll.Types (VoteState (..))

instance Arbitrary BlockVersionModifier where
    arbitrary = genericArbitrary
    shrink = genericShrink

instance Arbitrary SystemTag where
    arbitrary =
        oneof . map (pure . SystemTag) $
        [os <> arch | os <- ["win", "linux", "mac"], arch <- ["32", "64"]]
    shrink = genericShrink

instance Arbitrary ProtocolMagic => Arbitrary UpdateVote where
    arbitrary = mkUpdateVote <$> arbitrary <*> arbitrary <*> arbitrary <*> arbitrary
    shrink = genericShrink

instance Arbitrary ProtocolMagic => Arbitrary UpdateProposal where
    arbitrary = do
        protocolMagic <- arbitrary
        upBlockVersion <- arbitrary
        upBlockVersionMod <- arbitrary
        upSoftwareVersion <- arbitrary
        upData <- HM.fromList <$> listOf1 arbitrary
        let upAttributes = mkAttributes ()
        ss <- fakeSigner <$> arbitrary
        pure $
            mkUpdateProposalWSign
                protocolMagic
                upBlockVersion
                upBlockVersionMod
                upSoftwareVersion
                upData
                upAttributes
                ss
    shrink = genericShrink

instance Arbitrary UpdateProposalToSign where
    arbitrary = genericArbitrary
    shrink = genericShrink

instance Arbitrary VoteState where
    arbitrary = genericArbitrary
    shrink = genericShrink

instance Arbitrary UpdateData where
    arbitrary = genericArbitrary
    shrink = genericShrink

instance Arbitrary ProtocolMagic => Arbitrary UpdatePayload where
    arbitrary = genericArbitrary
    shrink = genericShrink
