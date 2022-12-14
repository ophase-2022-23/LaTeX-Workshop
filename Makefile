all: clean compile clean

define compile_latex
	@latexmk --shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -lualatex *.tex
endef

define add_name_suffix
	@for file in *$(1); do \
		mv "$$file" "$${file%$(1)}$(2)$(1)"; \
	done
endef

compileCode:
	@echo "Compiling code"
	@make -C code

compileRegular:
	@rm -f options.cfg
	@echo "Compiling Regular documend..."
	$(call compile_latex)
	@mkdir -p build
	@mv *.pdf build

compileDarkMode:
	@echo "\PassOptionsToPackage{dark_mode}{algo-common}" > options.cfg
	@echo "Compiling Dark Mode..."
	$(call compile_latex)
	$(call add_name_suffix,.pdf,-darkmode)
	@mkdir -p build
	@mv *.pdf build

compile: compileCode compileRegular compileDarkMode

clean:
	@echo "Cleaning..."
	@latexmk -C
	@rm -f options.cfg
	@rm -f *.pdf
	@make -C code clean

cleanBuild:
	@echo "Cleaning build..."
	@rm -rf build
	@make -C code cleanBuild

cleanAll: clean cleanBuild
