CART := "zig-out/lib/cart.wasm"
OPTS := "-Drelease-small=true"

build:
	zig build {{OPTS}}

watch:
  w4 watch

run: build
	w4 run {{CART}}

run-native: build
	w4 run-native {{CART}}

bundle: build
	w4 bundle {{CART}} --title "Lander" \
		--html bundle/index.html \
		--windows bundle/lander-windows.exe \
		--mac bundle/lander-mac \
		--linux bundle/lander-linux

clean:
	rm -rf bundle zig-cache zig-out
