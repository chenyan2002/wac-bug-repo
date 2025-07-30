# steps to repo

* Run `./build.sh` to produce the original `main.wasm` and composed `composed.wasm`.
* `wasm-tools component wit main.wasm` shows
```
package component:main {
  interface res {
    resource res;
  }
  interface main {
    use res.{res};

    test: func(x: res);
  }
}
```
* `wasm-tools component wit composed.wasm` shows
```
package component:main {
  interface main {
    resource res;

    test: func(x: res);
  }
}
```
