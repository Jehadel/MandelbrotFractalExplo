play:
	love ./src/

love:
	mkdir -p dist
	cd src && zip -r ../dist/MandelbrotFractalExplo.love .

js: love
	love.js -c --title="Mandelbrot‘s fractal exploration" ./dist/MandelbrotFractalExplo.love ./dist/js
