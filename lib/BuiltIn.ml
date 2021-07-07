open Identifier
open Type
open Semantic

let memory_module_name = make_mod_name "Austral.Memory"

let memory_module =
  let i = make_ident in
  let pointer_type_name = i "Pointer" in
  let pointer_type_qname = make_qident (memory_module_name, pointer_type_name, pointer_type_name) in
  let typarams = [TypeParameter(i "T", FreeUniverse)]
  and type_t = TyVar (TypeVariable (i "T", FreeUniverse)) in
  let pointer_t = NamedType (pointer_type_qname, [type_t], FreeUniverse) in
  let pointer_type_def =
    (* type Pointer[T: Free]: Free is Unit *)
    STypeAliasDefinition (
        TypeVisOpaque,
        pointer_type_name,
        typarams,
        FreeUniverse,
        Unit
      )
  in
  let allocate_def =
    (* generic T: Free
       function Allocate(value: T): Pointer[T] *)
    SFunctionDeclaration (
        VisPublic,
        i "Allocate",
        typarams,
        [ValueParameter (i "value", type_t)],
        NamedType (pointer_type_qname, [type_t], FreeUniverse)
      )
  and load_def =
    (* generic T: Free
       function Load(pointer: Pointer[T]): T *)
    SFunctionDeclaration (
        VisPublic,
        i "Load",
        typarams,
        [ValueParameter (i "pointer", pointer_t)],
        type_t
      )
  and store_def =
    (* generic T: Free
       function Store(pointer: Pointer[T], value: T): Unit *)
    SFunctionDeclaration (
        VisPublic,
        i "Store",
        typarams,
        [ValueParameter (i "pointer", pointer_t); ValueParameter (i "value", type_t)],
        Unit
      )
  and deallocate_def =
    (* generic T: Free
       function Deallocate(pointer: Pointer[T]): Unit *)
    SFunctionDeclaration (
        VisPublic,
        i "Deallocate",
        typarams,
        [ValueParameter (i "pointer", pointer_t)],
        Unit
      )
  in
  let decls = [pointer_type_def; allocate_def; load_def; store_def; deallocate_def] in
  SemanticModule {
      name = memory_module_name;
      decls = decls;
      imported_classes = [];
      imported_instances = []
    }
