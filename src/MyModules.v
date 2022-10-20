Module Type ADDRESS.
  Parameter addr : Set.
End ADDRESS.

Module VALUE(A:ADDRESS).
  Inductive value : Set :=
  | DVALUE_Addr (a:A.addr)
  | DVALUE_nat (x:nat)
  .
End VALUE.

Module Type LanguageParams.
  Declare Module ADDR : ADDRESS.
  Module V := VALUE ADDR.
End LanguageParams.

Module Make_LanguageParams (ADDR' : ADDRESS) <: LanguageParams with Module ADDR := ADDR'.
  Module ADDR := ADDR'.
  Module V := VALUE ADDR.
End Make_LanguageParams.

Module MakeByte (LP : LanguageParams).
  Import LP.V.
  Inductive value_byte : Type :=
  | ExtractByte (v : value) (idx : nat) : value_byte
  .
End MakeByte.  

Module Type Memory (LP: LanguageParams).
  Import LP.
  Import V.

  Module Byte := MakeByte LP.
End Memory.

Module MakeMemory (LP : LanguageParams) <: Memory LP.
  Include Memory LP.
End MakeMemory.

Module Type Lang (LP: LanguageParams).
  Export LP.

  (* Memory *)
  Declare Module MEM : Memory LP.
  Export MEM.
End Lang.

Module Make_Lang (LP : LanguageParams) (MEM' : Memory LP) <: Lang LP
with Module MEM := MEM'.
  Include Lang LP with Module MEM := MEM'.
End Make_Lang.

Module Type InterpreterStack_common (LP : LanguageParams) (MEM : Memory LP).
  (* Lang seems to be necessary to cause the bug *)
  Module Language := Make_Lang LP MEM.

  Import LP.V.
End InterpreterStack_common.

Module Type InterpreterStack.
  Declare Module LP : LanguageParams.
  Declare Module MEM : Memory LP.
  Include InterpreterStack_common LP MEM.
End InterpreterStack.

Module Make_InterpreterStack (LP' : LanguageParams) (MEM' : Memory LP') <: InterpreterStack
with Module LP := LP' with Module MEM := MEM'.
  Include InterpreterStack with Module LP := LP' with Module MEM := MEM'.
End Make_InterpreterStack.
