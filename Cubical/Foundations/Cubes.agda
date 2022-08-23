{-

The Internal n-Cubes

-}
{-# OPTIONS --safe #-}
module Cubical.Foundations.Cubes where

open import Cubical.Foundations.Prelude hiding (Cube)
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Cubes.Base public
open import Cubical.Foundations.Cubes.HLevels
open import Cubical.Foundations.Cubes.External

open import Cubical.Data.Nat.Base
open import Cubical.Data.Sigma.Properties

open import Agda.Builtin.Reflection hiding (Type)
open import Agda.Builtin.List
open import Cubical.Reflection.Base

private
  variable
    ℓ : Level
    A : Type ℓ


{-

By mutual recursion, one can define the type of

- n-Cubes:
  Cube    : (n : ℕ) (A : Type ℓ) → Type ℓ

- Boundary of n-Cubes:
  ∂Cube   : (n : ℕ) (A : Type ℓ) → Type ℓ

- n-Cubes with Specified Boundary:
  CubeRel : (n : ℕ) (A : Type ℓ) → ∂Cube n A → Type ℓ

Their definitions are put in `Cubical.Foundations.Cubes.Base`,
to avoid cyclic dependence.

-}


-- The macro to transform between external and internal cubes

private
  add2Impl : List (Arg Term) →  List (Arg Term)
  add2Impl t =
    harg {quantity-ω} unknown ∷
    harg {quantity-ω} unknown ∷ t

macro

  fromCube : (n : ℕ) → Term → Term → TC Unit
  fromCube 0 p t = unify p t
  fromCube (suc n) p t = unify t
    (def (quote Cube→ΠCubeᵉ) (add2Impl (ℕ→ℕᵉTerm (suc n) v∷ p v∷ [])))

  toCube : (n : ℕ) → Term → Term → TC Unit
  toCube 0 p t = unify p t
  toCube (suc n) p t = unify t
    (def (quote ΠCubeᵉ→Cube) (add2Impl (ℕ→ℕᵉTerm (suc n) v∷ p v∷ [])))

  from∂Cube : (n : ℕ) → Term → TC Unit
  from∂Cube 0 t = typeError
    (strErr "Only work for n>0." ∷ [])
  from∂Cube (suc n) t = unify t
    (def (quote ∂Cube→∂ΠCubeᵉ) (add2Impl (ℕ→ℕᵉTerm (suc n) v∷ [])))

  to∂Cube : (n : ℕ) → Term → TC Unit
  to∂Cube 0 t = typeError
    (strErr "Only work for n>0." ∷ [])
  to∂Cube (suc n) t = unify t
    (def (quote ∂ΠCubeᵉ→∂Cube) (add2Impl (ℕ→ℕᵉTerm (suc n) v∷ [])))


{- Lower Cubes Back and Forth -}


fromCube0 : Cube 0 A → A
fromCube0 p = fromCube 0 p

fromCube1 : Cube 1 A → (i : I) → A
fromCube1 p = fromCube 1 p

fromCube2 : Cube 2 A → (i j : I) → A
fromCube2 p = fromCube 2 p

fromCube3 : Cube 3 A → (i j k : I) → A
fromCube3 p = fromCube 3 p

fromCube4 : Cube 4 A → (i j k l : I) → A
fromCube4 p = fromCube 4 p


to0Cube : A → Cube 0 A
to0Cube p = toCube 0 p

to1Cube : ((i : I) → A) → Cube 1 A
to1Cube p = toCube 1 p

toCube2 : ((i j : I) → A) → Cube 2 A
toCube2 p = toCube 2 p

toCube3 : ((i j k : I) → A) → Cube 3 A
toCube3 p = toCube 3 p

to4Cube : ((i j k l : I) → A) → Cube 4 A
to4Cube p = toCube 4 p


-- The 0-cube has no (or empty) boundary...

from∂1Cube : ∂Cube 1 A → (i : I) → Partial (i ∨ ~ i) A
from∂1Cube p = from∂Cube 1 p

from∂Cube2 : ∂Cube 2 A → (i j : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j) A
from∂Cube2 p = from∂Cube 2 p

from∂Cube3 : ∂Cube 3 A → (i j k : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k) A
from∂Cube3 p = from∂Cube 3 p

from∂4Cube : ∂Cube 4 A → (i j k l : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k ∨ l ∨ ~ l) A
from∂4Cube p = from∂Cube 4 p


to∂1Cube : ((i : I) → Partial (i ∨ ~ i) A) → ∂Cube 1 A
to∂1Cube p = to∂Cube 1 p

to∂Cube2 : ((i j : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j) A) → ∂Cube 2 A
to∂Cube2 p = to∂Cube 2 p

to∂Cube3 : ((i j k : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k) A) → ∂Cube 3 A
to∂Cube3 p = to∂Cube 3 p

to∂4Cube : ((i j k l : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k ∨ l ∨ ~ l) A) → ∂Cube 4 A
to∂4Cube p = to∂Cube 4 p


-- They're strict isomorphisms actually.
-- The following is an example.

private

  ret-Cube2 : {A : Type ℓ} (a : Cube 2 A) → toCube2 (fromCube2 a) ≡ a
  ret-Cube2 a = refl

  sec-Cube2 : (p : (i j : I) → A) → (i j : I) → fromCube2 (toCube2 p) i j ≡ p i j
  sec-Cube2 p i j = refl

  ret-∂Cube2 : {A : Type ℓ} (a : ∂Cube 2 A) → to∂Cube2 (from∂Cube2 a) ≡ a
  ret-∂Cube2 a = refl

  sec-∂Cube2 : (p : (i j : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j) A)
    → (i j : I) → PartialP (i ∨ ~ i ∨ j ∨ ~ j) (λ o → from∂Cube2 (to∂Cube2 p) i j o ≡ p i j o)
  sec-∂Cube2 p i j = λ { (i = i0) → refl ; (i = i1) → refl ; (j = i0) → refl ; (j = i1) → refl }


{-

  The n-cubes-can-always-be-filled is equivalent to be of h-level n

-}


{-

-- The property that, given an n-boundary, there always exists an n-cube extending this boundary
-- The case n=0 is not very meaningful, so we use `isContr` instead to keep its relation with h-levels.
-- It generalizes `isSet'` and `isGroupoid'`.

isCubeFilled : ℕ → Type ℓ → Type ℓ
isCubeFilled 0 = isContr
isCubeFilled (suc n) A = (∂ : ∂Cube (suc n) A) → CubeRel (suc n) A ∂


-- We have the following logical equivalences between h-levels and cube-filling

isOfHLevel→isCubeFilled : (n : HLevel) → isOfHLevel n A → isCubeFilled n A

isCubeFilled→isOfHLevel : (n : HLevel) → isCubeFilled n A → isOfHLevel n A


Their proofs are put in `Cubical.Foundations.Cubes.HLevels`.

-}


-- The macro to fill cubes under h-level assumptions

fillCubeSuc :
  (n : ℕᵉ) (h : isOfHLevel (ℕᵉ→ℕ (suc n)) A)
  (u : ∂ΠCubeᵉ (suc n) A) → _
fillCubeSuc n h u =
  let ∂ = ∂ΠCubeᵉ→∂Cube (suc n) u in
  CubeRel→ΠCubeRelᵉ (suc n) ∂ (isOfHLevel→isCubeFilled (ℕᵉ→ℕ (suc n)) h ∂)

macro
  fillCube : (n : ℕ) → Term → TC Unit
  fillCube 0 t = typeError
    (strErr "Only work for n>0." ∷ [])
  fillCube (suc n) t = unify t
    (def (quote fillCubeSuc) (add2Impl (ℕ→ℕᵉTerm n v∷ [])))


-- Some special cases

fillCube1 :
  (h : isOfHLevel 1 A)
  (u : (i : I) → Partial (i ∨ ~ i) A)
  (i : I) → A [ _ ↦ u i ]
fillCube1 h u = fillCube 1 h u

fillCube2 :
  (h : isOfHLevel 2 A)
  (u : (i j : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j) A)
  (i j : I) → A [ _ ↦ u i j ]
fillCube2 h u = fillCube 2 h u

fillCube3 :
  (h : isOfHLevel 3 A)
  (u : (i j k : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k) A)
  (i j k : I) → A [ _ ↦ u i j k ]
fillCube3 h u = fillCube 3 h u

fill4Cube :
  (h : isOfHLevel 4 A)
  (u : (i j k l : I) → Partial (i ∨ ~ i ∨ j ∨ ~ j ∨ k ∨ ~ k ∨ l ∨ ~ l) A)
  (i j k l : I) → A [ _ ↦ u i j k l ]
fill4Cube h u = fillCube 4 h u
