# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Update `README.md`.
- Update elixir version to [1.10](https://elixir-lang.org/blog/2020/01/27/elixir-v1-10-0-released/).

## [1.1.2] - 2019-12-09
### Fixed
- Fix calculator value format when the value is greater than or equal to `1000`.

## [1.1.1] - 2019-12-09
### Added
- Support proxy as an option.

### Removed
- Remove `Correios CEP` library.

## [1.1.0] - 2019-12-04
### Added
- Add `ExCorreios.find_address/1` for search an address by a given postal code.

### Fixed
- Fix multiple services calculation.

### Changed
- Improve `.gitlab-ci.yml`.

## [1.0.0] - 2019-09-06
### Added
- Create client to calculate shipping based on one or more services.

[Unreleased]: https://code.locaweb.com.br/locawebcommon/ex-correios/compare/master...HEAD
[1.1.2]: https://code.locaweb.com.br/locawebcommon/ex-correios/compare/v1.1.1...v1.1.2
[1.1.1]: https://code.locaweb.com.br/locawebcommon/ex-correios/compare/v1.1.0...v1.1.1
[1.1.0]: https://code.locaweb.com.br/locawebcommon/ex-correios/compare/v1.0.0...v1.1.0
[1.0.0]: https://code.locaweb.com.br/locawebcommon/ex-correios/compare/v0.1.0...v1.0.0
[0.1.0]: https://code.locaweb.com.br/locawebcommon/ex-correios/-/tags/v0.0.1
