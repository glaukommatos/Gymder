#  Gymder

## Building & Running

Build the `Gymder` target in Xcode to run either on a simulator or a connected iOS device.

## Testing

You can either run the tests via Xcode's testing UI or on the command line via a command similar to

    xcodebuild test -scheme Gymder -destination 'platform=iOS Simulator,name=iPhone 12 Pro'

## Thoughts

This was a fun toy to make and a great opportunity to practice some view programming and trying
out some new things. If you want to know more of my thoughts, I've included a lot of information
in comments at the top of many files.

## Todos

These are generally things I would like to do to make the app better, but that I need more time to do.

- [ ] Display some match details in the `MatchView`.
- [ ] See about moving what logic I can out of `CardPileView` and into a view model or similar.
- [ ] Add ability to reload once gyms are swiped (need to make some minor changes to `CardPileView` to support this).
- [ ] Improve relationship between `CardPileView` and its data source. I think there's room for improvement here.
- [ ] Add more tests.
- [ ] Respond in some sensible way to changes of location service permission without restarting the app.
- [ ] Use device-size specific version of the gym images.

## Screenshot 

<kbd>![Screenshot](https://raw.githubusercontent.com/glaukommatos/Gymder/main/screenshot.png "Screenshot")</kbd>

## Credits

Icons made by [Pixel Perfect](https://icon54.com/) from [Flaticon](https://www.flaticon.com)
