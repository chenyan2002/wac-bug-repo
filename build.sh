#wit-bindgen rust --stubs wit --world imports --runtime-path wit_bindgen_rt
#wit-bindgen rust --stubs wit --world root --runtime-path wit_bindgen_rt
#cp imports.rs virt/src/lib.rs
#cp root.rs main/src/lib.rs
#rm imports.rs
#rm root.rs
set -x

cargo build --target=wasm32-unknown-unknown
pushd target/wasm32-unknown-unknown/debug
wasm-tools component embed ../../../wit --world root main.wasm -o main.wasm
wasm-tools component new main.wasm -o main.wasm
wasm-tools component embed ../../../wit --world imports virt.wasm -o virt.wasm
wasm-tools component new virt.wasm -o virt.wasm
wasm-tools component embed ../../../wit --world exports exports.wasm -o exports.wasm
wasm-tools component new exports.wasm -o exports.wasm
wac compose --dep wasi:io=../../../wit/deps/io.wit --dep virt:imports=./virt.wasm --dep root:component=./main.wasm --dep virt:exports=./exports.wasm ../../../compose.wac -o composed.wasm
popd

