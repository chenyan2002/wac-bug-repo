wit-bindgen rust --stubs wit --world imports --runtime-path wit_bindgen_rt
wit-bindgen rust --stubs wit --world root --runtime-path wit_bindgen_rt
cp imports.rs virt/src/lib.rs
cp root.rs main/src/lib.rs
rm imports.rs
rm root.rs
cargo build --target=wasm32-wasip2
wac plug target/wasm32-wasip2/debug/main.wasm --plug target/wasm32-wasip2/debug/virt.wasm -o composed.wasm

