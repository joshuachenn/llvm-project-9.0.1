//
// Created by joshua on 2021/3/16.
//
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include "llvm/Transforms/EncodeFunctions/EncodeFunctions.h"

using namespace llvm;

namespace {
  struct EncodeFunctions : public FunctionPass {
    static char ID;
    EncodeFunctions() : FunctionPass(ID) {}
    bool runOnFunction(Function &F) override {
      errs() << "EncodeFunctions: " << F.getName() << "->";
      if (F.getName().compare("main") != 0) {
//        F.setName("joshua_"+F.getName());
        MD5 Hasher;
        MD5::MD5Result Hash;
        Hasher.update("joshua_");
        Hasher.update(F.getName());
        Hasher.final(Hash);

        SmallString<32> HexString;
        MD5::stringifyResult(Hash, HexString);
        F.setName(HexString);
      }

      errs() << F.getName() << "\r\n";
//      errs().write_escaped(F.getName()) << '\n';
      return false;
    }
  }; // end of struct EncodeFunctions
}  // end of anonymous namespace

char EncodeFunctions::ID = 0;

static RegisterPass<EncodeFunctions> X("encode", "Hello World Pass",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);

//static llvm::RegisterStandardPasses Y(
//    llvm::PassManagerBuilder::EP_EarlyAsPossible,
//[](const llvm::PassManagerBuilder &Builder,
//   llvm::legacy::PassManagerBase &PM) { PM.add(new EncodeFunctions()); });

Pass* llvm::createEncodeFunctions() {
  return new EncodeFunctions();
}