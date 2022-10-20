Require Import ModuleBugs.MyModules.

Require ExtrOcamlBasic.

Extraction Language OCaml.

Cd "ml/extracted".

Recursive Extraction Library MyModules.
