# Steps to repo

* Run `./build.sh` to produce the original `main.wasm` and composed `composed.wasm`.
* `wasm-tools component wit main.wasm` shows
```
package component:main {
  interface async-io {
    resource handle;
  }
  interface http-body {
    use async-io.{handle as body-handle};
    test: func(x: body-handle);
  }
  interface http-resp {
    use http-body.{body-handle};
    test: func(x: body-handle);
  }
  interface main {
    use http-body.{body-handle};
    test: func(x: body-handle);
  }
}
```
* `wasm-tools component wit composed.wasm` shows
```
package component:main {
  interface async-io {
    resource handle;
  }
  interface http-body {
    use async-io.{handle as body-handle};
    test: func(x: body-handle);
  }
  interface http-resp {
    use async-io.{handle as body-handle};
    test: func(x: body-handle);
  }
  interface main {
    use http-body.{body-handle};
    test: func(x: body-handle);
  }
}
```
