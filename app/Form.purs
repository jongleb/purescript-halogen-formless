module App.Form where

import Prelude

import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Formless as Formless
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- | This component will only handle output from Formless to keep
-- | things simple.
data Query a
  = HandleFormless (Formless.Message Query) a

-- | Yea, I know
type State = Unit

-- | Now we can create _this_ component's child query and child slot pairing.
type ChildQuery = Formless.Query Query FCQ FCS Aff
type ChildSlot = Unit

-- | Now we can create our form component. We'll essentially write a render
-- | function for Formless and pass it in.
component :: H.Component HH.HTML Query Unit Void Aff
component =
  H.parentComponent
    { initialState: const unit
    , render
    , eval
    , receiver: const Nothing
    }
  where

  render :: State -> H.ParentHTML Query ChildQuery ChildSlot Aff
  render _ =
    HH.div_
      [ HH.h2_
          [ HH.text "Formless" ]
      , HH.slot
          unit
          Formless.component
          { render: renderFormless }
          ( HE.input HandleFormless )
      , HH.hr_
      , HH.p_
          [ HH.text "Thanks for working on this form." ]
      ]

  eval
    :: Query
    ~> H.ParentDSL State Query ChildQuery ChildSlot Void Aff
  eval = case _ of
    HandleFormless _ a -> pure a


----------
-- Formless

-- | Your parent component must provide a ChildQuery type to Formless
-- | that represents what sorts of children it can have, and an accompanying
-- | child slot type. In this case we'll provide no child query or child slot.
-- |
-- | FCQ: Formless ChildQuery
-- | FCS: Formless ChildSlot
type FCQ = Const Void
type FCS = Unit


-- | Our render function has access to anything in Formless' State type, plus
-- | anything additional in your own state type.
renderFormless
  :: Formless.State
  -> Formless.HTML Query FCQ FCS Aff
renderFormless state =
  HH.div_
    [ HH.text "I'm in formless." ]