PYTHON = $(shell pyenv version)
MANAGE = $(PYTHON) manage.py
ENV = $(CURDIR)/env
PYTHON = $(ENV)/bin/python3
COVERAGE = $(ENV)/bin/coverage
COVERAGE_OPTS = --rcfile=coverage.cfg

all: start

start run: test
	$(MANAGE) runserver 0.0.0.0:8000

test: $(ENV)/bin/nose2 $(ENV)/bin/coverage
	$(MANAGE) test

$(ENV)/bin/nose2 $(ENV)/bin/coverage: requirements

requirements: migrate
	$(ENV)/bin/pip install -r requirements.txt
	touch $@

migrate: db
	$(MANAGE) migrate --noinput --fake-initial

db: env
	# Connect to postgres and create riker db if it hasn't been done already
	-launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	-createdb wordUp
	$(MANAGE) makemigrations
env:
	virtualenv --python=python3.4 env 

coverage: .coverage
	$(COVERAGE) erase
	$(COVERAGE) run $(COVERAGE_OPTS) -L $(MANAGE) test
	$(COVERAGE) report -m $(COVERAGE_OPTS)

coverage-xml: .coverage
	$(COVERAGE) xml $(COVERAGE_OPTS)
	touch $@

.coverage: $(ENV)/bin/coverage
	$(COVERAGE) html $(COVERAGE_OPTS)
	touch $@

shell: test
	$(MANAGE) shell

clean:
	rm -rf $(ENV)
	find . -iname '*.pyc' -exec rm {} \;

.PHONY: all clean start run test coverage coverage-xml shell
