SCHEMA_DIR = /usr/share/glib-2.0/schemas/
LOCALE_DIR = ./lLyrics-auto/locale/
USER_PLUGIN_DIR = ~/.local/share/rhythmbox/plugins/
SYSTEM_PLUGIN_DIR = /usr/lib/rhythmbox/plugins/
SYSTEM64_PLUGIN_DIR = /usr/lib64/rhythmbox/plugins/

install: schema locales
	@echo "Installing plugin files to $(USER_PLUGIN_DIR) ..."
	@mkdir -p $(USER_PLUGIN_DIR)
	@rm -r -f $(USER_PLUGIN_DIR)lLyrics-auto/
	@cp -r ./lLyrics-auto/ $(USER_PLUGIN_DIR)
	@echo "Done!"

install-systemwide: schema locales
	@if [ -d "$(SYSTEM_PLUGIN_DIR)rb" ]; then \
		echo "Installing plugin files to $(SYSTEM_PLUGIN_DIR) ..."; \
		sudo rm -r -f $(SYSTEM_PLUGIN_DIR)lLyrics-auto/; \
		sudo cp -r ./lLyrics-auto/ $(SYSTEM_PLUGIN_DIR); \
		sudo chmod -R 755 $(SYSTEM_PLUGIN_DIR)lLyrics-auto/; \
	else \
		echo "Installing plugin files to $(SYSTEM64_PLUGIN_DIR) ..."; \
		sudo rm -r -f $(SYSTEM64_PLUGIN_DIR)lLyrics-auto/; \
		sudo cp -r ./lLyrics-auto/ $(SYSTEM64_PLUGIN_DIR); \
		sudo chmod -R 755 $(SYSTEM64_PLUGIN_DIR)lLyrics-auto/; \
	fi
	@echo "Done!"

schema:
	@echo "Installing schema..."
	@sudo cp ./org.gnome.rhythmbox.plugins.llyrics.gschema.xml $(SCHEMA_DIR)
	@sudo glib-compile-schemas $(SCHEMA_DIR)
	@echo "... done!"

locales:
	@echo "Installing locales..."
	@for i in $(LOCALE_DIR)*.po; do \
		echo `basename $$i`; \
		lang=`basename $$i .po`; \
		install -d $(LOCALE_DIR)$$lang/LC_MESSAGES; \
		msgfmt -c $(LOCALE_DIR)$$lang.po -o $(LOCALE_DIR)$$lang/LC_MESSAGES/lLyrics-auto.mo; \
	done
	@echo "... done!"

uninstall:
	@echo "Removing schema file..."
	@sudo rm -f $(SCHEMA_DIR)org.gnome.rhythmbox.plugins.llyrics.gschema.xml
	@echo "Removing plugin files..."
	@rm -r -f $(USER_PLUGIN_DIR)lLyrics-auto/
	@sudo rm -r -f $(SYSTEM_PLUGIN_DIR)lLyrics-auto/
	@sudo rm -r -f $(SYSTEM64_PLUGIN_DIR)lLyrics-auto/
	@echo "Done!"

update-po-files:
	@echo "Update *.po files..."
	@cd $(LOCALE_DIR); \
	for i in *.po; do \
		echo `basename $$i`; \
		lang=`basename $$i .po`; \
		intltool-update -g messages $$lang; \
	done
