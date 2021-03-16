add_llvm_library( LLVMEncodeFunctions
        EncodeFunctions.cpp

#        PLUGIN_TOOL
#        opt
        ADDITIONAL_HEADER_DIRS
        ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms
        ${LLVM_MAIN_INCLUDE_DIR}/llvm/Transforms/EncodeFunctions

        DEPENDS
        intrinsics_gen
        )