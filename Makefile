OUTPUT := zig-out/lib/cart.wasm
OPTS := -Drelease-small=true

build: $(OUTPUT)

run: build
	w4 run $(OUTPUT)

bundle: build
	w4 bundle $(OUTPUT) --title "Lander" \
		--html bundle/lander.html \
		--windows bundle/lander-windows.exe \
		--mac bundle/lander-mac \
		--linux bundle/lander-linux

clean:
	rm -rf bundle zig-cache zig-out

$(OUTPUT): $(shell find src -type f)
	zig build $(OPTS)

.PHONY: build run bundle clean
