## [1.3.0] - 4-4-22
- Fixed as issue with the toggle button in the Settings repository list not considering all repos.
- Fixed an issue with the menu label color not updating after switching system appearance. 
- Only reload the batsignal message every hour instead of every time tickets are checked.

## [1.2.4] - 9-6-21
- Fixed issue that was leading to high CPU usage.

## [1.2.3] - 7-4-21
- Add logo and thanks to the open source community to the about page.

## [1.2.2] - 18-1-21
- Added a bunch of logging around ticket requests to try and track down increased CPU usage for some users.

## [1.2.1] - 5-1-21
- Fixed an issue that was preventing Valet from storing or retrieving tokens.

## [1.2.0] - 15-12-20
- Fixed menu bar coloring on Big Sur.
- Repos should now consistently appear in alphabetical order.
- Turns out we can fill in a bunch of the info for creating a personal access token on GitHub for you! 
- Added a mechanism to show server and error messages in to the menu bar.
- Added better error messaging for some token errors.
- Added support for ignoring specific issue statuses from JIRA.
- Added an option to disable showing PRs you've authored but aren't currently assigned to.
- Various small UI tweaks and fixes.

## [1.1.1] - 04-07-19
- Fixed an issue that was preventing some GitLab integrations from working

## [1.1.0] - 30-05-19
- Pull requests you've authored will now show in your list of PRs
- Added a snazzy little separator between issues and PRs in the menu bar
- Added a send logs button in the Settings menu, under the About tab
- Updated most images to look snappier on high resolution screens
- Don't show tickets for repos you've archived
- Group repos by owner in Settings list
- Improved feedback and error messages for networking
- Lots of small UI and layout improvements!


## [1.0.16] - 11-02-19
### Changed
- Fixed some logic that was causing it to sometimes be possible to see both token entry windows at the same time.
- Slightly increased time between get ticket requests to prevent rate limiting errors
- Fixed a bug that allowed you to sometimes add the same account twice
- Fixed a bug that allowed you to open the intro window and settings window simultaneously
- Improved versioning for internal beta builds
- Fixed the remove account button sometimes getting stuck disabled
- Fixed a startup crash related to identical repo names
- Added some better handling for network requests with multiple GitHub accounts


## [1.0.15] - 10-01-19
### Added
- Added some better handling for tokens that have been revoked.
- Added a message to the repo list in the settings page when you haven't got any repos.
- Added some messages to the menu bar if you only have a few issues. 
- Removed the keyboard shortcuts for settings and quit, people think they're weird.
- Settings will now show all repositories are watching in addition to ones you've got an issue or PR assigned to you in.
- Added some better error reporting so we can track down and fix any networking errors that may occur.

### Changed
- Fixed an issue with the add token window error handling.
- Fixed an issue with the add token window not resetting when reopened.
- The add token window shouldn't hang around longer than it's supposed to any more.
- Exclude .md files from builds, noone wants to read my nonsense anyways!


## [1.0.13] - 07-01-19
### Added
- Added some UI to catch people adding GitHub tokens without permissions to go get issues and PRs

### Changed
- Fixed the accounts window not updating correctly some times


## [1.0.12] - 06-01-19
### Changed
- Removed a JIRA button from the AddToken window that wasn't supposed to be there (yet)
- Disable the minus button in the add account view when you don't have any accounts to remove


## [1.0.11] - 03-01-19
### Added
- Fixed the save button not enabling/disabling itself when adding accounts from the settings window.

### Changed
- Fixed pasting a token into the text field not updating the save button.


## [1.0.10] - 01-01-19
### Added
- The 'Start Using Quests' button should now be disabled until you've entered all the info you need.
- Added some higher quality assets for the menu bar icons, should fix the icons appearing blurry on non-retina displays.

### Changed
- Fixed an issue with the auth window that would sometimes disable the 'Start Using Quests' button.
- Fixed GitHub API error responses sometimes not returning the proper status code.
- Added some more logging around network errors.
- Fixed the menu sometimes rendering twice on top of itself.


## [1.0.9] - 20-12-18
### Changed
- Disabled external updating for the app, the App Store handles this for us now!
- Set launch at login to disabled by default
- Removed the alpha tag from the settings page


## [1.0.8] - 19-12-18
### Changed
- Fixed token creation reminder text missing.


## [1.0.7] - 19-12-18
### Added
- Added a smarter algorithm to size the ticket menu based on the length of tickets in it.

### Changed
- Fixed the right margin in the menu bar not resizing itself correctly sometimes.


## [1.0.5] - 18-12-18
### Added
- The issue and PR counts in the menu bar should correctly color themselves in light mode now.

### Changed
- Removed JIRA support for app store builds - will be back in a later version.
- Moved the check for updates to trigger if you open the settings window and haven't checked in the last 24 hours.


## [1.0.4] - 10-12-18
### Added
- Added a link to the Steamclock privacy policy to the about page
- Added the option to anonymously send some system information to us. We promise to only use this to makes Quests better!
- Added some better handling of network connectivity problems.

### Changed
- Removed support for High Sierra.
- The intro token field now correctly clears itself when you change screens
- Made the GitHub token scope reminder clearer
- Opening settings when you have no tokens added will now always show the first use screen
- Redesigned the installer to be a little easier on the eyes


## [1.0.3] - 05-11-18
### Added
- Fixed version numbering to line up with an eventual external release.

### Changed
- Fixed an issue that was causing mock data to crash the app
- Fixed review requests getting sorted below issues. They should now correctly appear between PRs and issues.


## [1.0.2] - 28-10-18
### Added
- Added a check to make it so you can't add the same account twice
- Added a reminder to select the proper permissions when added a new GitHub or GitLab token

### Changed
- Removed line about needed to put the app in /Applications to enable auto updating
- Fixed background updates triggering a 'You're all caught up' message to show
- Fixed an issue that was causing some parts of menu items to be unclickable
- Fixed the settings window sometimes hiding under lots of other windows
- Fixed the intro window sitting on top of other apps


## [1.0.1] - 23-10-18
### Added
- Added some better error handling and feedback for when things go wrong
- Added some checks to make sure your access token has the correct permissions

### Changed
- Changed networking libraries to use our own instead of Alamofire
- Changed how automatic updates are tracked and downloaded.


## [1.0.0] - 15-10-18
### Added
- Added GitLab support! You'll now be able to add a personal access token for GitLab accounts from the Settings menu
- Added support for JIRA projects! You'll now be able to add your information for JIRA and see issues assigned to you in Quests
- Added automatic token migration for the old accounts system


### Changed
- Revamped the intial auth flow, moved account management into a tab on the settings page
- Added support for multiple accounts. If you've got multiple GitHub or GitLab accounts you'll now be able to add and see them all
- Added some fancy flashes to text fields to better highlight what's missing when adding a token
- Disabled auto updater until we're able to get it working properly


## [0.6.2] - 03-10-18
### Added

### Changed
- Fixed the settings window scrolling to prevent it sometimes breaking
- Fixed the settings window not closing when focused and cmd+w is pressed
- Changed settings window shortcut from cmd+s to cmd+, to match conventions
- Fixed some issues with how the settings page repos were laid out and managed
- Fixed the settings button in the menu not working if there was no token entered
- Disabled app sandboxing to allow auto updating to work


## [0.6.1] - 27-09-18
### Changed
- Fixed an issue preventing updates from downloading properly


## [0.6.0] - 26-09-18
### Added
- Added a Send Feedback button in the Settings window

### Changed
- Redesigned the settings window to be a little less disorganized


## [0.5.0] - 2018-09-17
### Added
- Added option to enable launch at login

### Changed
- Fixed Quit menu item missing from Auth Required menu


## [0.4.2]
### Added
- Added some instructions to manually build and push an update.
- Removed some old unused files.

### Changed
- Replaced pr, ticket and review request icons with higher res `.pdf`s


## [0.4.0] - 2018-08-15
### Added
Added support for automatic version checking and updating.


## [0.3.0] - 2018-08-15
### Added
- Added option to enable local notifications when you recieve new tickets.
- Added some basic analytics and crash support thru Fabric.
- Don't show local notifications for self-assigned tickets.
- Added shiny new app icon and branding!
- Added support for mocking data through JSON

### Changed
- Don't show local notifications for self-assigned tickets.
- Show the settings page after a successful token auth.
- Added shiny new app icon and branding!
- Fixed some inconsitencies with sizing and layout in the label views and menus.


## [0.2.3] - 2018-08-02
### Changed
- Changed how labels are laid out for issues. Can now take up a maximum of 60% of the available width and will truncate the issue title to do so.


## [0.2.2] - 2018-08-2
### Changed
- Changed how we handle failed network requests when retrieving tickets. Now each subsequent failure increases the time between requests, from 5 seconds to 30, 60, 120 and then 300 until a request succeeds.
- Reorganized some functions in StatusMenuViewModel to follow typical file layout (public, actions, private functions).


## [0.2.1] - 2018-08-02
### Changed
- Fixed not being able to quit from the pre-download menu.
- Added a loading icon to the status bar item


## [0.2.0] - 2018-07-12
### Added
- Added this changelog file!
