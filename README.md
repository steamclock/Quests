![Quests: Issue and PR tracking in your menu bar](https://raw.githubusercontent.com/steamclock/Quests/master/quests.png)

![Quests supports dark mode and light mode!](https://raw.githubusercontent.com/steamclock/Quests/master/quests_preview.png)

Quests is a MacOS tool written in Swift for versions 10.14 and up designed to track issue and PR status in your menu bar. It currently works with GitHub, GitLab and JIRA and is available [on the Mac App Store](https://apps.apple.com/ca/app/quests/id1447415753?mt=12).

## Contributing

Please read our [Contributing Guide](https://github.com/steamclock/Quests/blob/master/CONTRIBUTING.md) for more information about contributing code or reporting issues.

Using XCode 12 is encouraged, remember to open `Quests.xcworkspace` rather than `Quests.xcodeproj`.

### Cloning/Building Locally

1. Install or update to the latest version of Bundler with:

```bash
gem install bundler
```

2. In the project root directory, install the dependencies specified in the Gemfile.

```bash
bundle install
```

3. In the project root directory, install dependencies specified in the Podfile.

```bash
bundle exec pod install --repo-update
```

There seems to be some issues with [Apollo-iOS](https://github.com/apollographql/apollo-ios) and outdated version of NPM that will prevent people from building Quests locally.

Since Apollo relies on NPM to download and run some code generation tools, you'll need to [update NPM](https://stackoverflow.com/questions/8191459/how-do-i-update-node-js). If that doesn't work, you'll need to install the Apollo CLI tools globally (`npm install -g apollo`). Running `pod install` when you first download the app may help as well.

### SwiftLint

We use [SwiftLint](https://github.com/realm/SwiftLint) to encourage a common style of code. While the app should build and work without it, if you intend on submitting a PR it should not generate any new warnings or errors.

## License

Quests is released under the MIT License. [See LICENSE](https://github.com/steamclock/Quests/blob/master/LICENSE.md) for details.
