# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v1.0.0](https://github.com/voxpupuli/puppet-misp/tree/v1.0.0) (2019-03-03)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.6.0...v1.0.0)

**Breaking changes:**

- modulesync 2.5.1 and drop Puppet 4 [\#42](https://github.com/voxpupuli/puppet-misp/pull/42) ([bastelfreak](https://github.com/bastelfreak))
- Added new configuration options and dependencies [\#29](https://github.com/voxpupuli/puppet-misp/pull/29) ([liviuvalsan](https://github.com/liviuvalsan))

**Implemented enhancements:**

- Make MISP Git repository configurable [\#39](https://github.com/voxpupuli/puppet-misp/pull/39) ([bmcbm](https://github.com/bmcbm))

**Fixed bugs:**

- Fix dependency collisions on non-present ensure [\#44](https://github.com/voxpupuli/puppet-misp/pull/44) ([ananace](https://github.com/ananace))

**Closed issues:**

- Duplicate declarations for dependencies if they are `ensure =\> installed` [\#43](https://github.com/voxpupuli/puppet-misp/issues/43)

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#38](https://github.com/voxpupuli/puppet-misp/pull/38) ([bastelfreak](https://github.com/bastelfreak))

## [v0.6.0](https://github.com/voxpupuli/puppet-misp/tree/v0.6.0) (2018-09-06)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.5.0...v0.6.0)

**Implemented enhancements:**

- \(\#33\) Use selboolean instead of exec for SELinux [\#35](https://github.com/voxpupuli/puppet-misp/pull/35) ([ananace](https://github.com/ananace))

**Closed issues:**

- Can't install if SELinux is disabled [\#33](https://github.com/voxpupuli/puppet-misp/issues/33)

**Merged pull requests:**

- allow puppetlabs/stdlib 5.x [\#34](https://github.com/voxpupuli/puppet-misp/pull/34) ([bastelfreak](https://github.com/bastelfreak))
- Remove docker nodesets [\#28](https://github.com/voxpupuli/puppet-misp/pull/28) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#27](https://github.com/voxpupuli/puppet-misp/pull/27) ([bastelfreak](https://github.com/bastelfreak))
- Update metadata.json [\#24](https://github.com/voxpupuli/puppet-misp/pull/24) ([ppanero](https://github.com/ppanero))

## [v0.5.0](https://github.com/voxpupuli/puppet-misp/tree/v0.5.0) (2017-11-20)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.4.0...v0.5.0)

**Merged pull requests:**

- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#21](https://github.com/voxpupuli/puppet-misp/pull/21) ([bastelfreak](https://github.com/bastelfreak))

## [v0.4.0](https://github.com/voxpupuli/puppet-misp/tree/v0.4.0) (2017-09-17)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.3.0...v0.4.0)

**Merged pull requests:**

- Config changes to comply with MISP version 2.4.79  [\#17](https://github.com/voxpupuli/puppet-misp/pull/17) ([ppanero](https://github.com/ppanero))
- Version update [\#16](https://github.com/voxpupuli/puppet-misp/pull/16) ([ppanero](https://github.com/ppanero))

## [v0.3.0](https://github.com/voxpupuli/puppet-misp/tree/v0.3.0) (2017-06-24)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.2.3...v0.3.0)

**Merged pull requests:**

- release 0.3.0 [\#15](https://github.com/voxpupuli/puppet-misp/pull/15) ([bastelfreak](https://github.com/bastelfreak))
- Features [\#14](https://github.com/voxpupuli/puppet-misp/pull/14) ([ppanero](https://github.com/ppanero))
- README updated [\#12](https://github.com/voxpupuli/puppet-misp/pull/12) ([ppanero](https://github.com/ppanero))

## [v0.2.3](https://github.com/voxpupuli/puppet-misp/tree/v0.2.3) (2017-04-24)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.2.2...v0.2.3)

**Closed issues:**

- Failed to install crypt GPG [\#9](https://github.com/voxpupuli/puppet-misp/issues/9)

**Merged pull requests:**

- Version 0.2.3 dependencies fixed for case sensitive [\#10](https://github.com/voxpupuli/puppet-misp/pull/10) ([ppanero](https://github.com/ppanero))

## [v0.2.2](https://github.com/voxpupuli/puppet-misp/tree/v0.2.2) (2017-04-24)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v.0.2.1...v0.2.2)

**Closed issues:**

- Workflow in this module [\#6](https://github.com/voxpupuli/puppet-misp/issues/6)

**Merged pull requests:**

- Secrets for puppetforge publication [\#7](https://github.com/voxpupuli/puppet-misp/pull/7) ([ppanero](https://github.com/ppanero))

## [v.0.2.1](https://github.com/voxpupuli/puppet-misp/tree/v.0.2.1) (2017-04-21)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/v0.2.0...v.0.2.1)

## [v0.2.0](https://github.com/voxpupuli/puppet-misp/tree/v0.2.0) (2017-04-18)

[Full Changelog](https://github.com/voxpupuli/puppet-misp/compare/04d440d191d67d29d72ab672e41e8a3dea54eb74...v0.2.0)

**Merged pull requests:**

- Update from voxpupuli modulesync\_config [\#5](https://github.com/voxpupuli/puppet-misp/pull/5) ([traylenator](https://github.com/traylenator))
- Drop redundant tests directory [\#4](https://github.com/voxpupuli/puppet-misp/pull/4) ([traylenator](https://github.com/traylenator))
- Correct metadata for voxpupli publishing [\#3](https://github.com/voxpupuli/puppet-misp/pull/3) ([traylenator](https://github.com/traylenator))
- Add badges to README.md [\#2](https://github.com/voxpupuli/puppet-misp/pull/2) ([traylenator](https://github.com/traylenator))
- Update from voxpupuli modulesync\_config [\#1](https://github.com/voxpupuli/puppet-misp/pull/1) ([traylenator](https://github.com/traylenator))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
