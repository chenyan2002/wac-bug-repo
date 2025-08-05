# The conflicts

* The proxy component needs to import and export the same interface/resource (e.g., `async-io.handle`) in order to inject code before we call the actual imported interface.
* When we compose the proxy component with the main component, the `wac` script sees the an interface being used as both the import and export. When we mention an interface/resource from WIT (e.g., `main.test(x: body-handle)`), it's unclear whether this interface refers to the imported or the exported one. `wac` assumes that it's always the exported one. Under this convention, `async-io` has to be exported in the final WIT, otherwise, there is no way to call `main.test`. This is problematic as the exported `async-io` is really an internal interface that should be invisible from the outside.
* On the host side, with the original WIT file, the host is expecting `async-io` to be a host side resource. When loading the composed component, the component instance says that the `main.test(http-body)` takes a guest side resource. This leads to a type mismatch when calling `main.test`.
* There are probably a few solutions:

1) We extend the `wac` script to handle the notion of internal interface, or have a way to specify whether a handle is an imported one or an exported one when the interface is both imported and exported.
2) Leave `wac` as it is. On the host side wit-bindgen, we find a way to synthesize a guest side `async-io` from the host side, with the knowledge that the guest resource is merely a wrapper around the host resource, i.e., the `exports::async_io::GuestHandle` is implemented for the host `async_io::Handle` type.
3) In the proxy component, make `main.test` to take the `async_io::Handle` type, instead of `exports::async_io::GuestHandle`, and call `x.to_export()` to continue as usual.

# Steps to repo

* Run `./build.sh` to produce the original `main.wasm` and composed `composed.wasm`.
* `wasm-tools component wit main.wasm` shows
```
world root {
  import component:main/async-io;
  import component:main/http-body;
  import component:main/http-resp;

  export component:main/main;
}
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
world root {
  import component:main/async-io;
  import component:main/http-body;
  import component:main/http-resp;

  export component:main/async-io;
  export component:main/http-body;
  export component:main/http-resp;
  export component:main/main;
}
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


