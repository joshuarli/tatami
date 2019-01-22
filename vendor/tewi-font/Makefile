bdf = tewi-medium-11.bdf tewi-bold-11.bdf tewifw-medium-11.bdf tewifw-bold-11.bdf
pcf = $(bdf:%.bdf=out/%.pcf.gz)

.PHONY: all
all: $(pcf)
	mkfontdir out
	mkfontscale out

out:
	mkdir out

out/%.pcf.gz: %.bdf out
	bdftopcf $< | gzip -9 > $@

.PHONY: clean
clean:
	rm -rf out
