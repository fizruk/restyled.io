{-# LANGUAGE RecordWildCards #-}

module Model.User
    ( fetchMarketplacePlanForUser
    )
where

import ClassyPrelude

import Control.Error.Util (hoistMaybe)
import Control.Monad.Trans.Maybe
import Database.Persist
import Database.Persist.Sql (SqlPersistT)
import Model

fetchMarketplacePlanForUser
    :: MonadIO m => User -> SqlPersistT m (Maybe MarketplacePlan)
fetchMarketplacePlanForUser User {..} = runMaybeT $ do
    githubId <- hoistMaybe userGithubUserId
    githubLogin <- hoistMaybe userGithubUsername
    account <- MaybeT $ getBy $ UniqueMarketplaceAccount githubId githubLogin
    MaybeT $ get $ marketplaceAccountMarketplacePlan $ entityVal account